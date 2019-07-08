set :stage, :gimili
set :branch, (ENV['BRANCH'] || fetch(:branch, 'master'))
server 'gimili.ucsd.edu', user: 'conan', roles: %w{app db}
set :rails_env, "gimili"
if ENV["CAP_SSHKEY_GIMILI"]
  puts "Using key: #{File.join(ENV["HOME"], ENV["CAP_SSHKEY_GIMILI"])}"
  set :ssh_options, { keys: File.join(ENV["HOME"], ENV["CAP_SSHKEY_GIMILI"]) }
end
