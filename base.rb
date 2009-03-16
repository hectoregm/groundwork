# base.rb
# Author: Hector E. Gomez Morales <hectoregm AT gmail.com>

########## Initial Setup ##########

# Get environment variables
begin
  base_dir = ENV['BASE_PATH']
  edge_dir = ENV['EDGE_PATH']
  app_dir = Dir.pwd
  app_name = File.basename app_dir
  raise ScriptError, "Please setup env variables BASE_PATH and EDGE_PATH:" if base_dir.nil? or edge_dir.nil?
rescue ScriptError => e
  puts e.message
  puts "$ export EDGE_PATH=<path to edge rails directory>"
  puts "$ export BASE_PATH=<path to rails-template/base directory>"
  run("rm -rf #{app_dir}")
  Kernel::exit(1)
end

# Convenience Methods
def cp(source, destination)
  log 'cp', source
  run("cp #{source} #{destination}", false)
end

def cp_r(source, destination)
  log 'cp_r', source
  run("cp -Rp #{get_root(source)} #{destination}", false)
end

def rm(filename)
  log 'rm', filename
  run("rm #{filename}", false)
end

def rmdir(dir)
  log 'rmdir', dir
  run("rmdir #{dir}", false)
end

def get_root(relative_destination)
  @base_dir ||= ENV['BASE_PATH']
  File.join(@base_dir, relative_destination)
end

def get_source(relative_destination)
  destination = get_root(relative_destination)
  ouput = open(destination, 'r') { |file| file.read }
end

def root_config(filename)
  log 'config', filename
  file(filename, get_source(filename), false)
end

def spec(filename)
  log 'spec', filename
  file("spec/#{filename}", get_source("spec/#{filename}"), false)
end

def model(filename)
  log 'model', filename
  file("app/models/#{filename}", get_source("app/models/#{filename}"), false)
end

def controller(filename)
  log 'controller', filename
  file("app/controllers/#{filename}", get_source("app/controllers/#{filename}"), false)
end

def view(controller, filename)
  log 'view', filename
  file("app/views/#{controller}/#{filename}", get_source("app/views/#{controller}/#{filename}"), false)
end

def layout(filename)
  log 'layout', filename
  file("app/views/layouts/#{filename}", get_source("app/views/layouts/#{filename}"), false)
end

# Get rails edge code.
inside('vendor') do
  log('link', 'edge rails')
  run("ln -s #{edge_dir} rails", false)
end

########## Git Setup ##########

# Remove tmp directories
%w[tmp/pids tmp/sessions tmp/sockets tmp/cache].each do |dir|
  rmdir dir
end

# Delete unnecessary files.
%w[doc/README_FOR_APP public/index.html public/favicon.ico public/robots.txt].each do |file|
  rm file
end

# Hold empty directories making a .gitignore file
run("find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;", false)

# Copy database.yml for distribution use
cp "config/database.yml", "config/database.yml.example"

# Create  master .gitignore file
root_config '.gitignore'

# Initialize git repository
git :init

########## Dependecies Setup ##########

# Add plugins.
# plugin 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git', :submodule => true

# Install gems
gem "rspec", :lib => false, :env => 'test'
gem "rspec-rails", :lib => false, :env => 'test'
gem 'sevenwire-forgery', :lib => 'forgery', :env => 'test', :source => "http://gems.github.com"
gem 'notahat-machinist', :lib => 'machinist', :env => 'test', :source => "http://gems.github.com"
gem 'hectoregm-webrat', :lib => 'webrat', :env => 'test', :source => "http://gems.github.com"
gem 'aslakhellesoy-cucumber', :lib => 'cucumber', :env => 'test', :source => "http://gems.github.com"
gem "spicycode-rcov", :lib => 'rcov', :env => 'test', :source => "http://gems.github.com"
gem "haml"
gem "authlogic"

########## Dependecies Install ##########
rake 'gems:install', :sudo => true
rake 'gems:install', :sudo => true, :env => 'test'

##########  Testing Environment Setup ##########
generate :cucumber
generate :rspec
generate :forgery

# Get cucumber config and task files
root_config "cucumber.yml"
rakefile "cucumber.rake", get_source("lib/tasks/cucumber.rake")

# Integrate machinist to rspec and cucumber
spec "spec_helper.rb"
spec "blueprints.rb"
append_file('features/support/env.rb', "require File.join(Rails.root, 'spec', 'blueprints')\n")

# Get autotest config file.
root_config ".autotest"

########## Application Setup ##########
run("haml --rails .")

# Initializer for action_mailer configuration
initializer "action_mailer.rb", get_source("config/initializers/action_mailer.rb")

########## Authlogic Setup ##########

generate :session, "user_session"
generate :rspec_controller, "user_sessions"
generate :rspec_scaffold, "user", "login:string", "crypted_password:string",
"password_salt:string", "persistence_token:string", "login_count:integer",
"last_request_at:datetime", "last_login_at:datetime", "current_login_at:datetime",
"last_login_ip:string", "current_login_ip:string"

# Create routes for UserSession and Users (with Account singular alias)
route "map.resource :user_session, :users"
route "map.resource :account, :controller => \"users\""
route "map.root :controller => \"user_sessions\", :action => \"new\""

# Get models
model "user.rb"

# Get controllers
controller "application_controller.rb"
controller "user_sessions_controller.rb"
controller "users_controller.rb"

# Get views
view "users", "new.html.erb"
view "users", "edit.html.erb"
view "users", "_form.html.erb"
view "users", "show.html.erb"
view "user_sessions", "new.html.erb"

# Modify layouts
layout "application.html.erb"
rm "app/views/layouts/users.html.erb"

# Get authentication related cucumber features
cp_r "features/registration", "features"
cp_r "features/authentication", "features"

# Send initial commit
git :add => "."
git :commit => "-a -m 'Setting up a new rails app.'"

# Create database
rake 'db:migrate'
rake 'db:test:load'
