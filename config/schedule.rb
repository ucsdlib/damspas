every 1.hour do
  rake "aeon_requests:process_new"
end

every 1.day do
  rake "aeon_requests:revoke_old"
end
