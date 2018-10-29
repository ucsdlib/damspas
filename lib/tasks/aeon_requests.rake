namespace :aeon_requests do
  desc "Processes new aeon permission requests"
  task :process_new => :environment do
    puts 'rake started successfully'
    hardcoded_response = [{email: 'rake@example.com', work_pid: 'xx77777777'}]
    hardcoded_response.each do |response|
      results = Processors::NewRightsProcessor.new(response).process
    end
  end
end
