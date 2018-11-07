# record ids: [29426, 29427, 29428, 29429, 29430, 29431, 29432, 29433]
namespace :aeon_requests do
  desc 'Processes new aeon permission requests'
  task process_new: :environment do
    Processes::NewRightsProcessor.process_new
  end

<<<<<<< HEAD
  desc 'Processes expired permission requests'
  task revoke_old: :environment do
    Processes::NewRightsProcessor.revoke_old
=======
  task :revoke_old => :environment do
    WorkAuthorization.where("updated_at < ?", 1.month.ago).each do |auth|
      params = {work_pid: auth.work_pid, email: auth.user.email, aeon_id: auth.aeon_id}
      request = Processors::NewRightsProcessor.new(params)
      request.revoke
      request.set_to_expired
    end
>>>>>>> persist aeon transaction number in the work_auth model
  end
end
