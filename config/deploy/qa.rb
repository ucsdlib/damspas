set :stage, :qa
set :branch, 'feature/fix_deploy'
server 'lib-hydrahead-qa.ucsd.edu', user: 'conan', roles: %w{web app db}
set :rails_env, "qa"
if ENV["CAP_SSHKEY_QA"]
  puts "Using key: #{File.join(ENV["HOME"], ENV["CAP_SSHKEY_QA"])}"
  set :ssh_options, { keys: File.join(ENV["HOME"], ENV["CAP_SSHKEY_QA"]) }
end
