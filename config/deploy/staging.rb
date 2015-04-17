server "107.23.108.186", :app, :web, :db, :primary => true
ssh_options[:keys] = ["#{ENV['HOME']}/.ssh/id_rsa"]
set :deploy_to, "/rails/apps/repo_layer"
set :user, 'rails' # server user

set :default_environment, { "PATH" =>
    "/rails/common/ruby-1.9.2-p290/bin:#{deploy_to}/shared/bundle/ruby/1.9.1/bin:$PATH",
    "LD_LIBRARY_PATH" => "/rails/common/oracle/instantclient_11_2",
    "TNS_ADMIN" => "/rails/common/oracle/network/admin" }


namespace :deploy do
  after "deploy:update_code" do
    run "cp #{deploy_to}/shared/database.yml #{release_path}/config/database.yml"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end