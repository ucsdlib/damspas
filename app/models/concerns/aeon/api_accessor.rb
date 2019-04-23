require 'active_support/concern'

module Aeon
  module ApiAccessor
    extend ActiveSupport::Concern

    def client
      api_url = ENV.fetch('APPS_DHH_AEON_API') { :no_aeon_api_provided }
      api_key = ENV.fetch('APPS_DHH_AEON_KEY') { :no_aeon_key_provided }

      @client ||= RestClient::Resource.new(api_url, headers: {
        'X-AEON-API-KEY' => api_key,
        'content-type' => 'text/json'
      })
    end
  end
end
