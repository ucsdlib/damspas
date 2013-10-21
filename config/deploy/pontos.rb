set :stage, :pontos
server 'pontos.ucsd.edu', user: 'escowles', roles: %w{web app db}
set :rails_env, "pontos"
