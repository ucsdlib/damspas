set :stage, :pontos
set :branch, 'feature/search-within-results'
server 'pontos.ucsd.edu', user: 'rvm', roles: %w{app db}
set :rails_env, "pontos"
if ENV["CAP_SSHKEY_PONTOS"]
  puts "Using key: #{File.join(ENV["HOME"], ENV["CAP_SSHKEY_PONTOS"])}"
  set :ssh_options, { keys: File.join(ENV["HOME"], ENV["CAP_SSHKEY_PONTOS"]) }
end
