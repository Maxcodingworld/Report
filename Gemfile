source 'https://rubygems.org'

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

gem 'rails', '3.2.12'
gem 'rake','10.3.2'
gem 'i18n','0.6.4'
gem 'highline','1.6.18'
gem 'execjs' ,'1.4.0'
gem 'ruby-oci8','2.1.7'
gem "capistrano","2.14.2"
gem 'activerecord-oracle_enhanced-adapter','1.4.2'
gem 'activewarehouse-etl', '1.0.0'
gem 'will_paginate'

group :development, :test do
  gem 'debugger'
  gem 'factory_girl_rails' # Needed in dev for generating when running scaffold
  gem 'rspec-rails'
  gem 'rspec-http'
  gem 'cucumber-rails', :require => false
  gem 'capybara'
  gem 'guard'
  gem 'guard-cucumber'
  gem 'database_cleaner'
end


group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
