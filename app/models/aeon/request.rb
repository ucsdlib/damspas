module Aeon
  class Request < Hashie::Mash
    include Aeon::ApiAccessor

    def self.find(id)
      Aeon::Request.new(id: id)
    end

    def id
      self.transactionNumber
    end

    def id= value
      self.transactionNumber = value
    end

    def email
      self.username
    end

    def set_to_new
      update_status(Aeon::Queue::NEW_STATUS)
    end

    def set_to_processing
      update_status(Aeon::Queue::PROCESSING_STATUS)
    end

    def set_to_active
      update_status(Aeon::Queue::ACTIVE_STATUS)
    end

    def set_to_expired
      update_status(Aeon::Queue::EXPIRED_STATUS)
    end

    def available_routes
      client["/Requests/#{self.id}/routes"].get
    end

    def get_from_server
      Aeon::Request.new(JSON.parse(client["/Requests/#{self.id}"].get))
    end

    private

      def update_status(status)
        client["/Requests/#{id}/route"].post({
          'newStatus' => status
        }.to_json)
      end
  end
end
