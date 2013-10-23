require "rvm/capistrano"
set :rvm_ruby_string, '2.0.0'
set :rvm_type, :user

require 'bundler/capistrano'

require 'capistrano/ext/multistage'
set :stages, %w(production)
set :default_stage, 'production'

set :application, "movies"
set :scm, :git
set :repository, "git@github.com:trajkovvlatko/movies.git"

set :deploy_to, "/home/rails/apps/#{application}"
set :deploy_via, :remote_cache
set :copy_exclude, [ '.git' ]

set :user, "rails"
set :keep_releases, 2

namespace :deploy do
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "seed db"
  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=production"
  end

  desc "delete manifest"
  task :delete_manifest_yml do
    run "rm #{shared_path}/assets/manifest.yml"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'
after "deploy:update", "deploy:cleanup"
