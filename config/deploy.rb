#require 'bundler/capistrano'
#require 'capistrano/ext/multistage'
require "whenever/capistrano"
set :whenever_command, "bundle exec whenever"
set :whenever_environment, 'staging'


set :rvm_ruby_version, '1.9.3-p551'
#set :rbenv_ruby ,'1.9.2'
set :application, "repo_layer"
set :repo_url,  "git@github.com:Maxcodingworld/Report.git"
set :deploy_to, "/rails/apps/repo_layer"

set :tmp_dir, "/rails/apps/tmp" 


#set :branch, "master"
# set :deploy_via, :remote_cache
set :scm, :git
set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || "master"
#set :log_level, :debug
# ssh_options[:paranoid] = false
# ssh_options[:forward_agent] = true

set :ssh_options, {
  forward_agent: true,
  paranoid: false
}

set :scm_username, 'Maxcodingworld'
set :use_sudo, true

def deploy_password
  set :password, deploy_script_password rescue nil
end
deploy_password

# namespace :rvm1 do # https://github.com/rvm/rvm1-capistrano3/issues/45
#   desc "Setup bundle alias"
#   task :create_bundle_alias do
#     on release_roles :all do
#       execute %Q{echo "alias bundle='#{fetch(:rvm1_auto_script_path)}/rvm-auto.sh . bundle'" > ~/.bash_aliases}
#     end
#   end
# end
# after "rvm1:install:rvm", "rvm1:create_bundle_alias"

set :normalize_asset_timestamps, false

set :stages, %w{staging production}

set :default_stage, "staging"