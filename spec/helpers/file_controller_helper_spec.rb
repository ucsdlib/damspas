require 'spec_helper'
require 'ostruct'

RSpec.describe FileControllerHelper do
  describe '#localstore_filename' do
    it "should raise an ArgumentError error if no parameters passed" do
      expect { helper.localstore_filename }.to raise_error(ArgumentError)
    end

    describe 'with correct arguments' do
      it 'returns a localStore prefixed filename' do
        allow(Rails).to receive(:root).and_return('/app/path')
        expect(helper.localstore_filename('/pub/data2/dams/localStore/bb/37/89/62/8p',
                                          '20775-bb3789628p-0-4.jpg')).to eq('/app/path/localStore/bb/37/89/62/8p/20775-bb3789628p-0-4.jpg')
      end
    end
  end

  describe '#http_content_type' do
    describe 'without a datastream or filename' do
      it 'default to octet-stream' do
        expect(helper.http_content_type(nil,nil)).to eq('application/octet-stream')
      end
    end

    describe 'with a mimeType in the datastream' do
      let(:datastream) { OpenStruct.new(mimeType: 'application/json') }
      let(:filename) { 'file.json' }
      it 'use the datastream mimeType' do
        expect(helper.http_content_type(datastream,filename)).to eq('application/json')
      end
    end

    describe 'with a no mimetype in the datastream, but an xml filename' do
      let(:datastream) { OpenStruct.new() }
      let(:filename) { 'file.xml' }
      it 'default to application/xml' do
        expect(helper.http_content_type(datastream,filename)).to eq('application/xml')
      end
    end
  end
end
