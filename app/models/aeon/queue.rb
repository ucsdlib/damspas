# frozen_string_literal: true

module Aeon
  class Queue
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Model
    include Aeon::ApiAccessor

    # These correspond to the Aeon queue IDs
    NEW_STATUS = ENV.fetch('APPS_DHH_VRR_NEW_STATUS', 1).to_i
    PROCESSING_STATUS = ENV.fetch('APPS_DHH_VRR_PROCESSING_STATUS', 2).to_i
    ACTIVE_STATUS = ENV.fetch('APPS_DHH_VRR_ACTIVE_STATUS', 3).to_i
    EXPIRED_STATUS = ENV.fetch('APPS_DHH_VRR_EXPIRED_STATUS', 4).to_i

    ALL_IDS = [
      NEW_STATUS,
      PROCESSING_STATUS,
      ACTIVE_STATUS,
      EXPIRED_STATUS
    ].freeze
    QUEUE_LOCAL_NAMES = {
      NEW_STATUS => 'New',
      PROCESSING_STATUS => 'Processing',
      ACTIVE_STATUS => 'Active',
      EXPIRED_STATUS => 'Expired'
    }.freeze

    attr_accessor :id

    @@all = [] # rubocop:disable ClassVars

    def self.all(refresh = false)
      if refresh || @@all.blank?
        @@all = ALL_IDS.map do |id| # rubocop:disable ClassVars
          find(id)
        end
      end
      @@all
    end

    def self.all!
      JSON.parse(Aeon::Queue.new.client['/Queues'].get)
    end

    def self.find(id)
      Aeon::Queue.new(id: id)
    end

    def initialize(args = {})
      args.each do |k, v|
        send("#{k}=", v)
      end
    end

    def get_from_server # rubocop:disable AccessorMethodName
      client["/Queues/#{id}"].get
    end

    def properties
      return @properties if @properties.present?
      @properties = JSON.parse(get_from_server)
    end

    def name
      @name ||= properties['queueName']
    end

    def get_requests_from_server # rubocop:disable AccessorMethodName
      client["/Queues/#{id}/requests"].get
    end

    def requests(refresh = false)
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
