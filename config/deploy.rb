require 'bundler/capistrano'
require 'capistrano/ext/multistage'

set :rvm_ruby_version, '1.9.3-p551'
set :application, "repo_layer"
set :repository,  "git@github.com:Maxcodingworld/Report.git"
set :branch, "master"
set :deploy_via, :remote_cache
set :scm, :git

ssh_options[:paranoid] = false
ssh_options[:forward_agent] = true
set :scm_username, 'Maxcodingworld'
set :use_sudo, false

set :normalize_asset_timestamps, false

set :stages, ["staging", "production"]
set :default_stage, "staging"