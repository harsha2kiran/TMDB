set :domain, '' # ip address
set :application, '' # app name
set :deploy_to, "/home/rails/apps/#{application}"
set :branch, 'master'
set :rails_env, "production"

server domain, :app, :web
role :db, domain, :primary => true
role :web, domain, :primary => true
set :use_sudo, false

default_run_options[:pty] = true
