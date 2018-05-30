require 'spec_helper'

describe DamsObjectsHelper do
  describe '#SecureToken' do
    before(:each) do
      @obj_id = 'xy7612557h'
      @file_name = '0-2.mp3'
      @end_time = 1527201673
      @cmp_id = '0'
      @field_data = ["{\"filestore\":\"\",\"id\":\"1.wav\",\"quality\":\"24-bit, 44100.0 Hz, Dual channel (Stereo)\",\"size\":\"65511424\",\"sourcePath\":\"/pub/data2/dams/localStore/bb/76/12/55/7h\",\"sourceFileName\":\"DMCA10470.wav\",\"use\":\"audio-source\",\"label\":\"\",\"dateCreated\":\"2015-10-14T09:04:55-0700\",\"formatName\":\"WAVE\",\"mimeType\":\"audio/x-wave\"}", "{\"filestore\":\"\",\"id\":\"2.mp3\",\"quality\":\"192-bit, 44.1 kHz, Joint stereo (Stereo) channel\",\"size\":\"5943528\",\"sourcePath\":\"/pub/data2/dams/localStore/bb/76/12/55/7h\",\"sourceFileName\":\"20775-xy7612557h-0-2.mp3\",\"use\":\"audio-service\",\"label\":\"\",\"dateCreated\":\"2015-10-14T09:05:04-0700\",\"formatName\":\"MP3\",\"mimeType\":\"audio/mpeg\"}"]     
    end

    it 'builds secure token hash' do
      token_hash = 'PmlrN2SlpERuDYOS2fMIh4IRC4m9E_rNW1oPxl2Os1c='
      expect(helper.secure_token_hash(@end_time, @file_name, @obj_id, Rails.configuration.secure_token_audio_baseurl)).to include token_hash
    end

    it 'builds secure token and token expiration' do
      token = "#{Rails.configuration.secure_token_name}endtime=#{helper.secure_token_end_time}&#{Rails.configuration.secure_token_name}hash"
      expect(helper.secure_token(@field_data, @obj_id, @cmp_id, Rails.configuration.secure_token_audio_baseurl)).to include token
    end
    
    it 'builds secure token base URL' do
      base_url = helper.secure_token_base_url(@field_data, @obj_id, @cmp_id, Rails.configuration.secure_token_audio_baseurl)
      expect(base_url).to include "#{Rails.configuration.secure_token_audio_baseurl}xy/76/12/55/7h/#{helper.ark_naan}-xy7612557h-0-2.mp3"
    end
  end
end