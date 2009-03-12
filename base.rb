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

# Get rails edge code.
inside('vendor') do
  run "ln -s #{edge_dir} rails"
end

########## Git Setup ##########

# Remove tmp directories
%w[tmp/pids tmp/sessions tmp/sockets tmp/cache].each do |f|
  run("rmdir #{f}")
end

# Delete unnecessary files.
%w[doc/README_FOR_APP public/index.html public/favicon.ico public/robots.txt].each do |f|
  run("rm #{f}")
end

# Hold empty directories making a .gitignore file
run("find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;")

# Copy database.yml for distribution use
run "cp config/database.yml config/database.yml.example"

# Create  master .gitignore file
file '.gitignore', <<-CODE
.#*
*~
*#
config/database.yml
config/mongrel_cluster.yml
coverage
db/schema.rb
db/*.sqlite3
doc/api
doc/app
.DS_Store
log/*.log
log/*.pid
*.swp
tmp/**/*
vendor/rails
CODE

# Initialize git repository
git :init

########## Dependecies Setup ##########

# Add plugins.
# plugin 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git', :submodule => true

# Install gems
gem "dchelimsky-rspec", :lib => false, :env => 'test'
gem "dchelimsky-rspec-rails", :lib => false, :env => 'test'
gem 'sevenwire-forgery', :lib => 'forgery', :env => 'test'
gem 'notahat-machinist', :lib => 'machinist', :env => 'test'
gem "webrat",:env => 'test'
gem "aslakhellesoy-cucumber", :lib => 'cucumber', :env => 'test'
gem "authlogic"

# Hack because of bug in template code
run("sed -e \"s/'false'/false/\" config/environments/test.rb > test.rb")
run("mv test.rb config/environments/test.rb")


########## Dependecies Install ##########
rake 'gems:install', :sudo => true
rake 'gems:install', :sudo => true, :env => 'test'

##########  Testing Environment Setup ##########
generate :cucumber
generate :rspec
generate :forgery

# Get cucumber config and task files
run("cp #{base_dir}/cucumber.yml ./")
run("cp #{base_dir}/lib/tasks/cucumber.rake lib/tasks")

# Integrate machinist to rspec and cucumber
run("cp #{base_dir}/spec/spec_helper.rb spec/")
run("cp #{base_dir}/spec/blueprints.rb spec/")
run("echo \"require File.join(Rails.root, 'spec', 'blueprints')\" >> features/support/env.rb")

# Get autotest config file.
run "cp #{base_dir}/.autotest ./"

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
run "cp #{base_dir}/app/models/user.rb app/models/"

# Get controllers
run "cp #{base_dir}/app/controllers/application_controller.rb app/controllers/"
run "cp #{base_dir}/app/controllers/user_sessions_controller.rb app/controllers/"
run "cp #{base_dir}/app/controllers/users_controller.rb app/controllers/"

# Get views
run "cp #{base_dir}/app/views/users/new.html.erb app/views/users/"
run "cp #{base_dir}/app/views/users/edit.html.erb app/views/users/"
run "cp #{base_dir}/app/views/users/_form.html.erb app/views/users/"
run "cp #{base_dir}/app/views/users/show.html.erb app/views/users/"
run "cp #{base_dir}/app/views/user_sessions/new.html.erb app/views/user_sessions/"

# Modify layouts
run "cp #{base_dir}/app/views/layouts/application.html.erb app/views/layouts/"
run 'rm app/views/layouts/users.html.erb'

# Get authentication related cucumber features
run "cp -Rp #{base_dir}/features/registration features/"
run "cp -Rp #{base_dir}/features/authentication features/"

# Send initial commit
git :add => "."
git :commit => "-a -m 'Setting up a new rails app.'"

# Create database
rake 'db:migrate'
rake 'db:test:load'
