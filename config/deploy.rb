set :stages, %w(central_development production)
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