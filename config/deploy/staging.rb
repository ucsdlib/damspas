set :stage, :staging
server 'lib-hydrahead-staging.ucsd.edu', user: 'rvm', roles: %w{web app db}
set :rails_env, "staging"