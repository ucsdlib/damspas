set :stage, :production
set :branch, 'master'
server 'lib-hydrahead-prod.ucsd.edu', user: 'conan', roles: %w{web app db sitemap}
set :rails_env, "production"
if ENV["CAP_SSHKEY_PRODUCTION"]
  puts "Using key: #{File.join(ENV["HOME"], ENV["CAP_SSHKEY_PRODUCTION"])}"
  set :ssh_options, { keys: File.join(ENV["HOME"], ENV["CAP_SSHKEY_PRODUCTION"]) }
end
