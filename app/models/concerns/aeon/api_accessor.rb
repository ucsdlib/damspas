require 'active_support/concern'

module Aeon
  module ApiAccessor
    extend ActiveSupport::Concern

    def client
      # TODO: move to ENV vars
      api_url = 'https://spcoll-request.ucsd.edu/nonshib/api'
      api_key = 'c4aa6d6a-7d67-4e56-85c5-a704f0749907'

      @client ||= RestClient::Resource.new(api_url, headers: {
        'X-AEON-API-KEY' => api_key,
        'content-type' => 'text/json'
      })
    end
  end
end
