set :stage, :gimili
set :branch, 'develop'
server 'gimili.ucsd.edu', user: 'escowles', roles: %w{app db sitemap_noping}
set :rails_env, "gimili"
if ENV["CAP_SSHKEY_GIMILI"]
  puts "Using key: #{File.join(ENV["HOME"], ENV["CAP_SSHKEY_GIMILI"])}"
  set :ssh_options, { keys: File.join(ENV["HOME"], ENV["CAP_SSHKEY_GIMILI"]) }
end
