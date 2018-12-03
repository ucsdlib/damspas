module Aeon
  class Queue
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Model
    include Aeon::ApiAccessor

    NEW_STATUS = 70
    PROCESSING_STATUS = 71 
    ACTIVE_STATUS = 72
    EXPIRED_STATUS = 73
    ALL_IDS = [
      NEW_STATUS,
      PROCESSING_STATUS,
      ACTIVE_STATUS,
      EXPIRED_STATUS
    ]
    QUEUE_LOCAL_NAMES={
      70 => "New",
      71 => "Processing",
      72 => "Active",
      73 => "Expired"
    }

    attr_accessor :id, :properties, :name

    @@all = []

    def self.all(refresh=false)
      if refresh || @@all.blank?
        @@all = ALL_IDS.map do |id|
          self.find(id)
        end
      end
      return @@all
    end

    def self.all!
      JSON.parse(Aeon::Queue.new.client["/Queues"].get)
    end

    def self.find(id)
      Aeon::Queue.new(id: id)
    end

    def initialize(args = {})
      args.each do |k,v|
        send("#{k}=", v)
      end
    end

    def get_from_server
      client["/Queues/#{self.id}"].get
    end

    def properties
      return @properties if @properties.present?
      @properties = JSON.parse(self.get_from_server)
    end

    def name
      @name ||= self.properties['queueName']
    end

    def get_requests_from_server
      client["/Queues/#{self.id}/requests"].get
    end

    def requests(refresh=false)
      return @requests if @requests.present? && !refresh

      requests_json = JSON.parse(get_requests_from_server)
      @requests = requests_json.map do |request|
        Aeon::Request.new(request)
      end
      @requests
    end

    # For active model
    def persisted?
      false
    end

    def to_model
      self
    end
  end
end
