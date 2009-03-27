set :stages, %w(central_development production public_production)
set :default_stage, "central_development"
require 'capistrano/ext/multistage'

set :application, "actionlog"
set :repository, "/home/neumann/git/actionlog.git"
set :local_repository, "."

set :user, "neumann"
set :use_sudo, false

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm, :git
set :deploy_via, :remote_cache

role :app, "s15339212.onlinehome-server.info"
role :web, "s15339212.onlinehome-server.info"
role :db,  "s15339212.onlinehome-server.info", :primary => true

#deploy.task :start, :roles => :app do
#    run "cd #{current_path} && #{try_runner} nohup script/spin-central_development"
#end

namespace :passenger do
  task :restart do
    invoke_command "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  task :restart do
    passenger.restart
  end

  task :start do
    # NOP
  end

  task :stop do
    # NOP
  end
end
