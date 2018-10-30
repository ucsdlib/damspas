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

    def set_to_processing
      update_status(Queue::PROCESSING_STATUS)
    end

    def set_to_completed
      update_status(Queue::COMPLETED_STATUS)
    end

    def available_routes
      client["/Requests/#{self.id}/routes"].get
    end

    def get_from_server
      client["/Requests/#{self.id}"].get
    end

    private
      def update_status status
        client["/Requests/#{self.id}/route"].post({
          "newStatus" => status
        }.to_json)
      end
  end
end
