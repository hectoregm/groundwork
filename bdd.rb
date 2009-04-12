begin
  raise ScriptError, "This application has already BDD tools" if File.exists?('spec/spec_helper.rb')
rescue ScriptError => e
  puts e.message
  Kernel::exit(1)
end

load_template('../rails-templates/methods.rb') unless self.respond_to?(:spec)

# Add gem dependencies
gem "rspec", :lib => false, :env => 'test'
gem "rspec-rails", :lib => false, :env => 'test'
gem 'webrat', :lib => 'webrat', :env => 'test'
gem 'aslakhellesoy-cucumber', :lib => 'cucumber', :env => 'test', :source => "http://gems.github.com", :version => '= 0.2.3.3'
gem 'spicycode-rcov', :lib => 'rcov', :env => 'test', :source => "http://gems.github.com"
gem 'remarkable_rails', :env => 'test'
gem 'hectoregm-email_spec', :lib => 'email_spec', :env => 'test', :source => "http://gems.github.com"
gem 'sevenwire-forgery', :lib => 'forgery', :env => 'test', :source => "http://gems.github.com"
gem 'notahat-machinist', :lib => 'machinist', :env => 'test', :source => "http://gems.github.com"

# Install gems
rake 'gems:install', :sudo => true, :env => 'test'

# Generate files
generate :cucumber
generate :rspec
generate :email_spec
generate :forgery

# Configuration rspec
spec 'rcov.opts'
spec 'spec.opts'
spec 'spec_helper.rb'
spec 'blueprints.rb'
spec 'spec_helpers/controller_spec_helper.rb'
spec 'spec_helpers/application_spec_helper.rb'

# Configuration cucumber
root_config 'cucumber.yml'
feature 'support/env.rb'
feature 'support/paths.rb'
rakefile 'cucumber.rake', get_source('lib/tasks/cucumber.rake')
rakefile 'rcov.rake', get_source('lib/tasks/rcov.rake')

# Email testing setup
feature 'step_definitions/custom_email_steps.rb'
feature 'step_definitions/email_steps.rb'

# Get autotest config file.
root_config ".autotest"
