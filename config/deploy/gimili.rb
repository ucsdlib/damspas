set :stage, :gimili
set :branch, 'release/1.0-beta'
server 'gimili.ucsd.edu', user: 'rvm', roles: %w{web app db}
set :rails_env, "gimili"
if ENV["CAP_SSHKEY_GIMILI"]
  puts "Using key: #{File.join(ENV["HOME"], ENV["CAP_SSHKEY_GIMILI"])}"
  set :ssh_options, { keys: File.join(ENV["HOME"], ENV["CAP_SSHKEY_GIMILI"]) }
end
