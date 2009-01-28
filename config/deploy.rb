set :application, "actionlog"
set :repository, "/vol/git/actionlog.git" 

set :user, "root"
set :use_sudo, false

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/webuser/capistrano/actionlog"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm, :git
set :deploy_via, :remote_cache

role :app, "actionlog.dynalias.com"
role :web, "actionlog.dynalias.com"
role :db,  "actionlog.dynalias.com", :primary => true