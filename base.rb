# base.rb
# Author: Hector E. Gomez Morales <hectoregm AT gmail.com>

########## Initial Setup ##########

# Get environment variables
begin
  base_dir = ENV['BASE_PATH']
  raise ScriptError, "Please setup env variable BASE_PATH" if base_dir.nil?
rescue ScriptError => e
  puts e.message
  puts "$ export BASE_PATH=<path to groundwork/base directory>"
  Kernel::exit(1)
end

# Mix in convenience methods
load_template(File.join(base_dir, "../methods.rb"))

# Apply subtemplates
FEATURES.each do |feature|
  apply_template(feature)
end

# Add ruby-debug to development environment (ruby18 only)
environment("require 'ruby-debug' if RUBY_VERSION < '1.9'", :env => 'development')

# Send initial commit
git :add => "."
git :commit => "-a -m 'Setting up a new rails app.'"

# Create database
rake 'db:migrate'
rake 'db:test:load'
