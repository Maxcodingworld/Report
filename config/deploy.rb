require 'bundler/capistrano'
# set :whenever_command, "bundle exec whenever"
# require 'whenever/capistrano'
set :ssh_options, { :forward_agent => true }
set :application, "repo_layer"
set :repository,  "git@github.com:Maxcodingworld/Report.git"
set :deploy_via, :remote_cache
set :scm, :git
set :ssh_options, { :forward_agent => true }

set :scm_username, 'Maxcodingworld'
set :use_sudo, false
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
delayed_job_flag = false

# set ssh password if passed through script
def deploy_password
  set :password, deploy_script_password rescue nil
end
deploy_password

def aws_staging name
  task name do
    set :branch, "master"
    yield
    set :default_environment, { "PATH" =>
    "/rails/common/ruby-1.9.2-p290/bin:#{deploy_to}/shared/bundle/ruby/1.9.1/bin:$PATH",
    "LD_LIBRARY_PATH" => "/rails/common/oracle/instantclient_11_2",
    "TNS_ADMIN" => "/rails/common/oracle/network/admin" }
    role :app, location
    role :web, location
    role :db, location, :primary => true
    set :user, 'rails'
    ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]
  end
end

aws_staging :ec2_staging do
  set :branch, "myrepo"
  set :application, "repo_layer"
  set :deploy_to, "/rails/apps/repo_layer"
  set :location, "107.23.108.186"
end

# after "deploy:create_symlink", "deploy:update_crontab"
# after "deploy:create_symlink", "deploy:delayed_job_restart"

namespace :deploy do
  after "deploy:update_code" do
    run "cp #{deploy_to}/shared/database.yml #{release_path}/config/database.yml"
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :db do
    run "cd #{release_path} && bundle exec whenever --update-crontab #{application}"
  end

  desc "Restart the delayed_job process"
  task :delayed_job_restart, :roles => :app do
    # if delayed_job_flag
    #   run "cd #{current_path} && RAILS_ENV=production script/delayed_job restart"
    # end
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
