# frozen_string_literal: true

require 'spec_helper'
require 'net/http'
require 'json'

# rubocop:disable Metrics/BlockLength, Rails/HttpPositionalArguments
describe FileController do
  let(:unit) { DamsUnit.create pid: 'xx48484848', name: 'Test Unit', description: 'Description', code: 'tu', uri: 'http://example.com/' }
  let(:pub_col) { DamsAssembledCollection.create titleValue: 'Sample Assembled Collection', visibility: 'public' }
  let(:local_col) { DamsAssembledCollection.create titleValue: 'Sample Assembled Collection', visibility: 'local' }
  let(:license_local) { DamsLicense.create permissionType: 'localDisplay' }
  let(:otherRights_metadata) { DamsOtherRight.create permissionType: 'metadataDisplay' }
  let(:otherRights_local) { DamsOtherRight.create permissionType: 'localDisplay' }
  let(:image_content) { 'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7==' }
  let(:jpeg_content) { '/9j/4AAQSkZJRgABAQEAAQABAAD//2gAIAQEAAD8AVN//2Q==' }
  let(:wav_content) { '//tQxAAAAAAAAAAAAASW5mbwAAAA8AAAACAAACcQCAgICAgICAgVVVVVVVVVVVVVQ==' }
  let(:mp3_content) { '//tQxAASW5mbwAAAA/8QU34oKC/0FBVTEFNRTMuOTkuNVQ==' }
  let(:mov_content) { '//tQxAAAAAAAAAAAAAMOVVIDEOVVVVVVVVVVVVVQ==' }
  let(:mp4_content) { '//tQxAASW5mbwAAAA/MP4VIDEO/0FBVTEFNRTMuOTkuNVQ==' }

  after do
    [unit, pub_col, local_col, license_local, otherRights_metadata, otherRights_local].each(&:delete)
  end

  describe 'public object image download' do
    let(:obj) do
      DamsObject.create(titleValue: 'Image Test', typeOfResource: 'still image', unitURI: [unit.pid],
                        copyright_attributes: [{ status: 'Public domain' }])
    end

    before do
      obj.assembledCollectionURI = [pub_col.pid]
      obj.add_file(Base64.decode64(image_content), '_1.tif', 'image_source.tif')
      obj.add_file(Base64.decode64(jpeg_content), '_2.jpg', 'image_service.jpg')
      obj.save
      solr_index obj.pid
    end

    after do
      obj.delete
    end

    describe 'curator' do
      it 'can download the source file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(200)
      end

      it 'can download the service file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(200)
      end
    end

    describe 'public user' do
      it 'cannot download the source file' do
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(403)
      end

      it 'can download service file' do
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(200)
      end
    end

    describe 'campus user' do
      it 'cannot download the source file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(403)
      end

      it 'can download the service file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'UCSD IP/metadata-only file download' do
    let(:obj) do
      DamsObject.create(titleValue: 'Image Test', typeOfResource: 'still image',
                        unitURI: [unit.pid], copyright_attributes: [{ status: 'Unknown' }])
    end

    before do
      obj.assembledCollectionURI = [local_col.pid]
      obj.otherRightsURI = otherRights_metadata.pid
      obj.add_file(Base64.decode64(image_content), '_1.tif', 'image_source.tif')
      obj.add_file(Base64.decode64(jpeg_content), '_2.jpg', 'image_service.jpg')
      obj.add_file(Base64.decode64(jpeg_content), '_3.jpg', 'image_medium.jpg')
      obj.save
      solr_index obj.pid
    end

    after do
      obj.delete
    end

    describe 'curator' do
      it 'can download the source file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(200)
      end

      it 'can download the service file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(200)
      end

      it 'can download the preview image for the object viewer' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_3.jpg'
        expect(response).to have_http_status(200)
      end
    end

    describe 'public user' do
      it 'cannot download the source file' do
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(403)
      end

      it 'cannot download service file' do
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the preview image for the object viewer' do
        get :show, id: obj.pid, ds: '_3.jpg'
        expect(response).to have_http_status(403)
      end
    end

    describe 'campus user' do
      it 'cannot download the source file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the service file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(403)
      end

      it 'can download the preview image for the object viewer' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_3.jpg'
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'public metadata-display file download' do
    let(:obj) do
      DamsObject.create(titleValue: 'Image Test', typeOfResource: 'still image',
                        unitURI: [unit.pid], copyright_attributes: [{ status: 'Unknown' }])
    end

    before do
      obj.assembledCollectionURI = [pub_col.pid]
      obj.otherRightsURI = otherRights_metadata.pid
      obj.add_file(Base64.decode64(image_content), '_1.tif', 'image_source.tif')
      obj.add_file(Base64.decode64(jpeg_content), '_2.jpg', 'image_service.jpg')
      obj.save
      solr_index obj.pid
    end

    after do
      obj.delete
    end

    describe 'curator' do
      it 'can download the source file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(200)
      end

      it 'can download the service file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(200)
      end
    end

    describe 'public user' do
      it 'cannot download the source file' do
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(403)
      end

      it 'cannot download service file' do
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(403)
      end
    end

    describe 'campus user' do
      it 'cannot download the source file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the service file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'OtherRights localDisplay file download' do
    let(:obj) do
      DamsObject.create(titleValue: 'Image Test', typeOfResource: 'still image',
                        unitURI: [unit.pid], copyright_attributes: [{ status: 'Unknown' }])
    end

    before do
      obj.assembledCollectionURI = [local_col.pid]
      obj.otherRightsURI = otherRights_local.pid
      obj.add_file(Base64.decode64(image_content), '_1.tif', 'image_source.tif')
      obj.add_file(Base64.decode64(jpeg_content), '_2.jpg', 'image_service.jpg')
      obj.save
      solr_index obj.pid
    end

    after do
      obj.delete
    end

    describe 'curator' do
      it 'can download the source file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(200)
      end

      it 'can download the service file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(200)
      end
    end

    describe 'public user' do
      it 'cannot download the source file' do
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(403)
      end

      it 'cannot download service file' do
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(403)
      end
    end

    describe 'campus user' do
      it 'cannot download the source file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(403)
      end

      it 'can download the service file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'License localDisplay file download' do
    let(:obj) do
      DamsObject.create(titleValue: 'Image Test', typeOfResource: 'still image',
                        unitURI: [unit.pid], copyright_attributes: [{ status: 'Unknown' }])
    end

    before do
      obj.assembledCollectionURI = [local_col.pid]
      obj.licenseURI = license_local.pid
      obj.add_file(Base64.decode64(image_content), '_1.tif', 'image_source.tif')
      obj.add_file(Base64.decode64(jpeg_content), '_2.jpg', 'image_service.jpg')
      obj.save
      solr_index obj.pid
    end

    after do
      obj.delete
    end

    describe 'curator' do
      it 'can download the source file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(200)
      end

      it 'can download the service file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(200)
      end
    end

    describe 'public user' do
      it 'cannot download the source file' do
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(403)
      end

      it 'cannot download service file' do
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(403)
      end
    end

    describe 'campus user' do
      it 'cannot download the source file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_1.tif'
        expect(response).to have_http_status(403)
      end

      it 'can download the image file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_2.jpg'
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'License localDisplay audio download' do
    let(:obj) do
      DamsObject.create(titleValue: 'MP3 Test', typeOfResource: 'sound recording',
                        unitURI: [unit.pid], copyright_attributes: [{ status: 'Unknown' }])
    end

    before do
      obj.assembledCollectionURI = [local_col.pid]
      obj.licenseURI = license_local.pid
      obj.add_file(Base64.decode64(mp3_content), '_1.wav', 'audio_source.wav')
      obj.add_file(Base64.decode64(mp3_content), '_2.mp3', 'audio_service.mp3')
      obj.save
      solr_index obj.pid
    end

    after do
      obj.delete
    end

    describe 'curator download' do
      it 'can download the master file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_1.wav'
        expect(response).to have_http_status(200)
      end

      it 'can download the mp3 derivative' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_2.mp3'
        expect(response).to have_http_status(200)
      end
    end

    describe 'public download' do
      it 'cannot download the master file' do
        get :show, id: obj.pid, ds: '_1.wav'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the mp3 derivative' do
        get :show, id: obj.pid, ds: '_2.mp3'
        expect(response).to have_http_status(403)
      end
    end

    describe 'campus download' do
      it 'cannot download the master file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_1.wav'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the mp3 derivative' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_2.mp3'
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'OtherRights localDisplay audio download' do
    let(:obj) do
      DamsObject.create(titleValue: 'MP3 Test', typeOfResource: 'sound recording',
                        unitURI: [unit.pid], copyright_attributes: [{ status: 'Unknown' }])
    end

    before do
      obj.assembledCollectionURI = [local_col.pid]
      obj.otherRightsURI = otherRights_local.pid
      obj.add_file(Base64.decode64(mp3_content), '_1.wav', 'audio_source.wav')
      obj.add_file(Base64.decode64(mp3_content), '_2.mp3', 'audio_service.mp3')
      obj.save
      solr_index obj.pid
    end

    after do
      obj.delete
    end

    describe 'curator download' do
      it 'can download the master file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_1.wav'
        expect(response).to have_http_status(200)
      end

      it 'can download the mp3 derivative' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_2.mp3'
        expect(response).to have_http_status(200)
      end
    end

    describe 'public download' do
      it 'cannot download the master file' do
        get :show, id: obj.pid, ds: '_1.wav'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the mp3 derivative' do
        get :show, id: obj.pid, ds: '_2.mp3'
        expect(response).to have_http_status(403)
      end
    end

    describe 'campus download' do
      it 'cannot download the master file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_1.wav'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the mp3 derivative' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_2.mp3'
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'License localDisplay video download' do
    let(:obj) do
      DamsObject.create(titleValue: 'Video Test', typeOfResource: 'video',
                        unitURI: [unit.pid], copyright_attributes: [{ status: 'Unknown' }])
    end

    before do
      obj.assembledCollectionURI = [local_col.pid]
      obj.licenseURI = license_local.pid
      obj.add_file(Base64.decode64(mov_content), '_1.mov', 'audio_source.mov')
      obj.add_file(Base64.decode64(mp4_content), '_2.mp4', 'audio_service.mp4')
      obj.add_file(Base64.decode64(jpeg_content), '_4.jpg', 'image_icon.jpg')
      obj.save
      solr_index obj.pid
    end

    after do
      obj.delete
    end

    describe 'curator download' do
      it 'can download the master file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_1.mov'
        expect(response).to have_http_status(200)
      end

      it 'can download the mp4 derivative' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_2.mp4'
        expect(response).to have_http_status(200)
      end

      it 'can download the image icon' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_4.jpg'
        expect(response).to have_http_status(200)
      end
    end

    describe 'public download' do
      it 'cannot download the master file' do
        get :show, id: obj.pid, ds: '_1.mov'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the mp4 derivative' do
        get :show, id: obj.pid, ds: '_2.mp4'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the image icon' do
        get :show, id: obj.pid, ds: '_4.jpg'
        expect(response).to have_http_status(403)
      end
    end

    describe 'campus download' do
      it 'cannot download the master file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_1.mov'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the mp4 derivative' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_2.mp4'
        expect(response).to have_http_status(403)
      end

      it 'can download the image icon' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_4.jpg'
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'OtherRights localDisplay video download' do
    let(:obj) do
      DamsObject.create(titleValue: 'Video Test', typeOfResource: 'video',
                        unitURI: [unit.pid], copyright_attributes: [{ status: 'Unknown' }])
    end

    before do
      obj.assembledCollectionURI = [local_col.pid]
      obj.otherRightsURI = otherRights_local.pid
      obj.add_file(Base64.decode64(mov_content), '_1.mov', 'audio_source.mov')
      obj.add_file(Base64.decode64(mp4_content), '_2.mp4', 'audio_service.mp4')
      obj.add_file(Base64.decode64(jpeg_content), '_4.jpg', 'image_icon.jpg')
      obj.save
      solr_index obj.pid
    end

    after do
      obj.delete
    end

    describe 'curator download' do
      it 'can download the master file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_1.mov'
        expect(response).to have_http_status(200)
      end

      it 'can download the mp4 derivative' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_2.mp4'
        expect(response).to have_http_status(200)
      end

      it 'can download the image icon' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_4.jpg'
        expect(response).to have_http_status(200)
      end
    end

    describe 'public download' do
      it 'cannot download the master file' do
        get :show, id: obj.pid, ds: '_1.mov'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the mp4 derivative' do
        get :show, id: obj.pid, ds: '_2.mp4'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the image icon' do
        get :show, id: obj.pid, ds: '_4.jpg'
        expect(response).to have_http_status(403)
      end
    end

    describe 'campus download' do
      it 'cannot download the master file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_1.mov'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the mp4 derivative' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_2.mp4'
        expect(response).to have_http_status(403)
      end

      it 'can download the image icon' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_4.jpg'
        expect(response).to have_http_status(200)
      end
    end
  end

  describe 'OtherRights metadataDisplay audio download' do
    let(:obj) do
      DamsObject.create(titleValue: 'MP3 Test', typeOfResource: 'sound recording',
                        unitURI: [unit.pid], copyright_attributes: [{ status: 'Unknown' }])
    end

    before do
      obj.assembledCollectionURI = [local_col.pid]
      obj.otherRightsURI = otherRights_metadata.pid
      obj.add_file(Base64.decode64(mp3_content), '_1.wav', 'audio_source.wav')
      obj.add_file(Base64.decode64(mp3_content), '_2.mp3', 'audio_service.mp3')
      obj.save
      solr_index obj.pid
    end

    after do
      obj.delete
    end

    describe 'curator download' do
      it 'can download the master file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_1.wav'
        expect(response).to have_http_status(200)
      end

      it 'can download the mp3 derivative' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_2.mp3'
        expect(response).to have_http_status(200)
      end
    end

    describe 'public download' do
      it 'cannot download the master file' do
        get :show, id: obj.pid, ds: '_1.wav'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the mp3 derivative' do
        get :show, id: obj.pid, ds: '_2.mp3'
        expect(response).to have_http_status(403)
      end
    end

    describe 'campus download' do
      it 'cannot download the master file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_1.wav'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the mp3 derivative' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_2.mp3'
        expect(response).to have_http_status(403)
      end
    end
  end
  describe 'OtherRights metadataDisplay video download' do
    let(:obj) do
      DamsObject.create(titleValue: 'Video Test', typeOfResource: 'video',
                        unitURI: [unit.pid], copyright_attributes: [{ status: 'Unknown' }])
    end

    before do
      obj.assembledCollectionURI = [local_col.pid]
      obj.otherRightsURI = otherRights_metadata.pid
      obj.add_file(Base64.decode64(mov_content), '_1.mov', 'audio_source.mov')
      obj.add_file(Base64.decode64(mp4_content), '_2.mp4', 'audio_service.mp4')
      obj.add_file(Base64.decode64(jpeg_content), '_4.jpg', 'image_icon.jpg')
      obj.save
      solr_index obj.pid
    end

    after do
      obj.delete
    end

    describe 'curator download' do
      it 'can download the master file' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_1.mov'
        expect(response).to have_http_status(200)
      end

      it 'can download the mp4 derivative' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_2.mp4'
        expect(response).to have_http_status(200)
      end

      it 'can download the image icon' do
        sign_in User.create!(provider: 'developer')
        get :show, id: obj.pid, ds: '_4.jpg'
        expect(response).to have_http_status(200)
      end
    end

    describe 'public download' do
      it 'cannot download the master file' do
        get :show, id: obj.pid, ds: '_1.mov'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the mp4 derivative' do
        get :show, id: obj.pid, ds: '_2.mp4'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the image icon' do
        get :show, id: obj.pid, ds: '_4.jpg'
        expect(response).to have_http_status(403)
      end
    end

    describe 'campus download' do
      it 'cannot download the master file' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_1.mov'
        expect(response).to have_http_status(403)
      end

      it 'cannot download the mp4 derivative' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_2.mp4'
        expect(response).to have_http_status(403)
      end

      it 'can download the image icon' do
        sign_in_anonymous '132.239.0.3'
        get :show, id: obj.pid, ds: '_4.jpg'
        expect(response).to have_http_status(200)
      end
    end
  end
end
# rubocop:enable Rails/HttpPositionalArguments, Metrics/BlockLength
