namespace :aeon_requests do
  desc "Processes new aeon permission requests"
  task :process_new => :environment do
    puts 'rake started successfully'
    hardcoded_response = [{email: 'rake@example.com', work_title: 'anything'}]
    hardcoded_response.each do |response|
      results = Processors::NewRightsProcessor.new(response).process
    end
  end
end
