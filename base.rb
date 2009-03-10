# base.rb
# Author: Hector E. Gomez Morales <hectoregm AT gmail.com>

########## Initial Setup ##########

# Base dir of code.
base_dir = '~/Projects/github/rails-templates/base'

# Get rails edge code.
inside('vendor') do
  run "ln -s ~/Projects/github/rails rails"
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

# Install gem'
#gem "dchelimsky-rspec", :lib => false, :version => "1.1.99.7"
#gem "dchelimsky-rspec-rails", :lib => false, :version => ">= 1.1.99.7"
gem "webrat"
gem "cucumber"
gem "authlogic"

########## Authlogic Setup ##########

generate :session, "user_session"
generate :controller, "user_sessions"
generate :scaffold, "users", "login:string", "crypted_password:string",
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

# Send initial commit
git :add => "."
git :commit => "-a -m 'Setting up a new rails app.'"

# Create database
rake "db:migrate"
