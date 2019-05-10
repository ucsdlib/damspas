# record ids: [29426, 29427, 29428, 29429, 29430, 29431, 29432, 29433]
namespace :aeon_requests do
  desc 'Processes new aeon permission requests'
  task process_new: :environment do
    Processors::NewRightsProcessor.process_new
  end

  desc 'Remove expired aeon derived permissions'
  task revoke_old: :environment do
    Processors::NewRightsProcessor.revoke_old
  end
end
