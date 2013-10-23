set :stage, :gimili
server 'gimili.ucsd.edu', user: 'escowles', roles: %w{web app db}
set :rails_env, "gimili"
