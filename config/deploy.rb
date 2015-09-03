# config valid only for current version of Capistrano

lock '3.4.0'

set :stages, %w(production)

set :application, 'healthypath'
set :repo_url, 'https://istateasedev:DE2023te@bitbucket.org/istateasedev/healthypath.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "#{fetch(:deploy_to)}"

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'public/system')

set :whenever_environment,  ->{ fetch :rails_env, fetch(:stage, "production") }
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
set :rvm_ruby_version, '2.2.1'
set :rvm_roles, [:app]
set :rvm_type, :user

namespace :foreman do
  desc "Export the Procfile to Supervisor scripts"
  task :export do
    on roles(:app) do
      within release_path do
        as :istateasedev do
          execute "cd /var/www/html/healthypath/current && /home/istateasedev/.rvm/wrappers/ruby-2.2.1/bundle exec foreman export supervisord /etc/supervisor/conf.d \
            -f ./Procfile \
            -e /var/www/html/healthypath/production.env \
            -a #{fetch(:application)} \
            -u istateasedev -l /var/www/html/healthypath/shared/log"
        end
      end
    end
  end

  desc "Stop for supervisor processes"
  task :stop do
    on roles(:app) do
      execute "sudo supervisorctl stop #{fetch(:application)}:*"
    end
  end

  desc "Reread for supervisor control"
  task :reread do
    on roles(:app) do
      execute "sudo supervisorctl reread"
    end
  end

  desc "Update for supervisor control"
  task :update do
    on roles(:app) do
      execute "sudo supervisorctl update"
    end
  end
end

after "deploy:started", "foreman:stop"
after "deploy:finished", "foreman:export"
after "deploy:finished", "foreman:reread"
after "deploy:finished", "foreman:update"