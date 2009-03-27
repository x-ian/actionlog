# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/neumann/capistrano/actionlog_public_production"

set :rails_env, "public_production"
