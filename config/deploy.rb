set :stages, %w(central_development production)
set :default_stage, "central_development"
require 'capistrano/ext/multistage'

set :application, "actionlog"
set :repository, "/vol/git/actionlog.git" 
set :local_repository, "."

set :user, "root"
set :use_sudo, false

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm, :git
set :deploy_via, :remote_cache

role :app, "actionlog.dynalias.com"
role :web, "actionlog.dynalias.com"
role :db,  "actionlog.dynalias.com", :primary => true