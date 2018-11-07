# record ids: [29426, 29427, 29428, 29429, 29430, 29431, 29432, 29433]
namespace :aeon_requests do
  desc "Processes new aeon permission requests"
  task :process_new => :environment do
    queue = Aeon::Queue.find(Aeon::Queue::NEW_STATUS)
    queue.requests.each do |request|

      ## DEV
      request[:work_pid] = 'xx77777777'

      request.set_to_processing
      Processors::NewRightsProcessor.new(request).process
      request.set_to_completed
    end
  end

  task :revoke_old => :environment do
    WorkAuthorization.where("updated_at < ?", 1.month.ago).each do |auth|
      params = {work_pid: auth.work_pid, email: auth.user.email, aeon_id: auth.aeon_id}
      request = Processors::NewRightsProcessor.new(params)
      request.revoke
    end
  end
end
