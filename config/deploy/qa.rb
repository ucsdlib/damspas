set :stage, :qa
set :branch, 'qa'
server 'lib-hydrahead-qa.ucsd.edu', user: 'rvm', roles: %w{web app db sitemap_noping}
set :rails_env, "qa"
if ENV["CAP_SSHKEY_QA"]
  puts "Using key: #{File.join(ENV["HOME"], ENV["CAP_SSHKEY_QA"])}"
  set :ssh_options, { keys: File.join(ENV["HOME"], ENV["CAP_SSHKEY_QA"]) }
end
