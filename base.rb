# base.rb
# from Hector E. Gomez M.
# based on bort template"

# Get rails edge code.
inside('vendor') do
  run "ln -s ~/Projects/github/rails rails"
end

# Remove tmp directories
["./tmp/pids", "./tmp/sessions", "./tmp/sockets", "./tmp/cache"].each do |f|
  run("rmdir ./#{f}")
end

# Delete unnecessary files.
%w{doc/README_FOR_APP public/index.html public/favicon.ico public/robots.txt}.each do |f|
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

# Add plugins.
#plugin 'authlogic', :git => 'git://github.com/binarylogic/authlogic.git', :submodule => true
# plugin 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git', :submodule => true

# Install gem'
#gem "dchelimsky-rspec", :lib => false, :version => "1.1.99.7"
#gem "dchelimsky-rspec-rails", :lib => false, :version => ">= 1.1.99.7"
gem "webrat"
gem "cucumber"
gem "authlogic"

# Send initial commit
git :add => "."

git :commit => "-a -m 'Setting up a new rails app.'"

generate :session, "user_session"
generate :controller, "user_sessions"

route "map.resource :user_session"
route "map.root :controller => \"user_sessions\", :action => \"new\""
