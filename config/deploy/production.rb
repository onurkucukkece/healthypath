set :stage, :production
set :deploy_to, "/var/www/apps/healthypath"
set :rails_env, 'production'
set :password, ask('Server password:', 'healthypath.istweb.biz', echo: false)
server 'istweb.biz', user: 'istateasedev', password: fetch(:password), roles: %w{web app db}