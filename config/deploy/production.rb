set :stage, :production
server 'lib-hydrahead.ucsd.edu', user: 'rvm', roles: %w{web app db}
set :rails_env, "production"
