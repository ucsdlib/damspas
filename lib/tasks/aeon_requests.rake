namespace :aeon_requests do
  desc "Processes new aeon permission requests"
  task :process_new => :environment do
    queue = Aeon::Queue.find(Aeon::Queue.NEW_STATUS)
    queue.requests.each do |request|
      Processors::NewRightsProcessor.new(request).process
    end
  end
end
