# base.rb
# Author: Hector E. Gomez Morales <hectoregm AT gmail.com>

########## Initial Setup ##########

# Get environment variables
begin
  base_dir = ENV['BASE_PATH']
  app_dir = Dir.pwd
  app_name = File.basename app_dir
  raise ScriptError, "Please setup env variable BASE_PATH" if base_dir.nil?
rescue ScriptError => e
  puts e.message
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

def feature(filename)
  log 'feature', filename
  file("features/#{filename}", get_source("features/#{filename}"), false)
end

def model(filename)
  log 'model', filename
  file("app/models/#{filename}", get_source("app/models/#{filename}"), false)
end

def controller(filename)
  log 'controller', filename
  file("app/controllers/#{filename}", get_source("app/controllers/#{filename}"), false)
end

def helper(filename)
  log 'helper', filename
  file("app/helpers/#{filename}", get_source("app/helpers/#{filename}"), false)
end

def view(controller, filename)
  log 'view', "#{filename} for #{controller}"
  file("app/views/#{controller}/#{filename}", get_source("app/views/#{controller}/#{filename}"), false)
end

def layout(filename)
  log 'layout', filename
  file("app/views/layouts/#{filename}", get_source("app/views/layouts/#{filename}"), false)
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
gem 'webrat', :lib => 'webrat', :env => 'test'
gem 'aslakhellesoy-cucumber', :lib => 'cucumber', :env => 'test', :source => "http://gems.github.com"
gem 'spicycode-rcov', :lib => 'rcov', :env => 'test', :source => "http://gems.github.com"
gem 'carlosbrando-remarkable', :lib => 'remarkable', :env => 'test', :source => "http://gems.github.com"
gem 'bmabey-email_spec', :lib => 'email_spec', :env => 'test', :source => "http://gems.github.com"
gem 'sevenwire-forgery', :lib => 'forgery', :env => 'test', :source => "http://gems.github.com"
gem 'notahat-machinist', :lib => 'machinist', :env => 'test', :source => "http://gems.github.com"
gem 'haml'
gem 'authlogic', :version => ">= 2.0.1"

########## Dependecies Install ##########
rake 'gems:install', :sudo => true
rake 'gems:install', :sudo => true, :env => 'test'

##########  Testing Environment Setup ##########
generate :cucumber
generate :rspec
generate :email_spec
generate :forgery

# Configuration rspec
spec 'spec.opts'
spec 'spec_helper.rb'
spec 'blueprints.rb'
spec 'spec_helpers/controller_spec_helper.rb'

# Configuration cucumber
root_config 'cucumber.yml'
feature 'support/env.rb'
feature 'support/paths.rb'
rakefile 'cucumber.rake', get_source('lib/tasks/cucumber.rake')

# Email testing setup
feature 'step_definitions/custom_email_steps.rb'
feature 'step_definitions/email_steps.rb'

# Get autotest config file.
root_config ".autotest"

########## Application Setup ##########
run("haml --rails .")

# Initializer for action_mailer configuration
initializer "action_mailer.rb", get_source("config/initializers/action_mailer.rb")

########## Authlogic Setup ##########

# Rspec helper for authlogic
spec 'spec_helpers/authentication_spec_helper.rb'

generate :session, "user_session"

# Create routes
log 'route', 'config/routes.rb'
file('config/routes.rb', get_source('config/routes.rb'), false)

# Get migration
log 'migrate', 'db/migrate/create_users.rb'
file('db/migrate/20090316040456_create_users.rb',
     get_source('db/migrate/20090316040456_create_users.rb'), false)

# Get models
model "user.rb"
model "user_mailer.rb"
model "user_observer.rb"

# Add observer
gsub_file('config/environment.rb', /#\s*(config.active_record.observers =) :cacher, :garbage_collector, :forum_observer/, '\1 :user_observer')

# Get controllers
controller "application_controller.rb"
controller "user_sessions_controller.rb"
controller "users_controller.rb"
controller "password_resets_controller.rb"
controller 'home_controller.rb'

# Get views
view "users", "new.html.haml"
view "users", "edit.html.haml"
view "users", "_form.html.haml"
view "users", "show.html.haml"
view "user_sessions", "new.html.haml"
view "user_mailer", "activation.text.html.haml"
view "user_mailer", "reset_password_instructions.text.html.haml"
view "user_mailer", "signup_notification.text.html.haml"
view "password_resets", "new.html.haml"
view "password_resets", "edit.html.haml"
view 'home', 'index.html.haml'

#Get helpers
helper 'layout_helper.rb'

# Modify layouts
layout "application.html.haml"
layout 'single_column.html.haml'

# Get stylesheets
cp_r "public/stylesheets/sass", "public/stylesheets"

# Get authentication related cucumber features
cp_r "features/registration", "features"
cp_r "features/authentication", "features"
cp_r "features/password_reset", "features"

# Get rspec tests
spec 'models/user_spec.rb'
spec 'models/user_mailer_spec.rb'
spec 'controllers/users_controller_spec.rb'
spec 'controllers/user_sessions_controller_spec.rb'
spec 'controllers/password_resets_controller_spec.rb'

# Send initial commit
git :add => "."
git :commit => "-a -m 'Setting up a new rails app.'"

# Create database
rake 'db:migrate'
rake 'db:test:load'
