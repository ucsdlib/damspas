env 'RAILS_RELATIVE_URL_ROOT', '/dc'

# Note: The AEON API currently has a problem processing concurrent requests
#   So we're offsetting the cron times to try avoiding that for now
#   This should be able to be deleted in the future
case @environment
when 'production'
  every 1.hour do
    rake "aeon_requests:process_new"
  end
  every 1.day do
    rake "aeon_requests:revoke_old"
  end
when 'staging'
  every '50 * * * *' do
    rake "aeon_requests:process_new"
  end
  every 1.day, at: '1:00 am' do
    rake "aeon_requests:revoke_old"
  end
end
