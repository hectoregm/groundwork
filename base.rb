# base.rb
# Author: Hector E. Gomez Morales <hectoregm AT gmail.com>

########## Initial Setup ##########

# Get environment variables
begin
  base_dir = ENV['BASE_PATH']
  @app_dir = Dir.pwd
  raise ScriptError, "Please setup env variable BASE_PATH" if base_dir.nil?
rescue ScriptError => e
  puts e.message
  puts "$ export BASE_PATH=<path to rails-template/base directory>"
  run("rm -rf #{app_dir}")
  Kernel::exit(1)
end

# Mix in convenience methods
load_template(File.join(base_dir, "../methods.rb"))

# Apply Git template
apply_template(:git)

# Apply BDD template
apply_template(:bdd)

# Apply Authlogic template
apply_template(:authlogic)

# Send initial commit
git :add => "."
git :commit => "-a -m 'Setting up a new rails app.'"

# Create database
rake 'db:migrate'
rake 'db:test:load'
