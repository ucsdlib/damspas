namespace :aeon_requests do
  desc "Processes new aeon permission requests"
  task :process_new => :environment do
    puts 'it works!'
    hardcoded_response = [{email: 'qa@example.com', work_title: 'anything'}]
    hardcoded_response.each do |response|
      results = Processors::NewRightsProcessor.new(response).process
    end
  end
end
