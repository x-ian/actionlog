# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/webuser/capistrano/actionlog"

set :rails_env, "central_development"

deploy.task :start, :roles => :app do
    run "cd #{current_path} && #{try_runner} nohup script/spin-central_development"
end
