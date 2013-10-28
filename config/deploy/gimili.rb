set :stage, :gimili
server 'gimili.ucsd.edu', user: 'rvm', roles: %w{web app db}
set :rails_env, "gimili"
set :ssh_options, { keys: File.join(ENV["HOME"], "keys", "bamboodev.nopassphrase") }
