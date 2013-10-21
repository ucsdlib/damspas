set :application, 'damspas'
set :repo_url, 'git@github.com:ucsdlib/damspas.git'

set :branch, 'feature/capistrano'

set :deploy_to, '/pub/capistrano'
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

set :linked_files, %w{config/database.yml config/fedora.yml config/solr.yml config/initializers/secret_token.rb}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :mkdir, release_path.join('tmp')
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :finishing, 'deploy:cleanup'

end
