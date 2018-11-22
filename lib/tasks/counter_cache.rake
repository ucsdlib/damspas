# reset work_authorizations_count values for all users
namespace :counter_cache do
  desc 'Reset user counter cache'
  task user_counter: :environment do
    User.reset_column_information
    User.all.each do |u|
      User.reset_counters u.id, :work_authorizations
    end
  end
end
