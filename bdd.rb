# BDD template. Uses rspec, cucumber and friends.
log 'template', 'Applying BDD template'

begin
  raise ScriptError, 'This application already has BDD tools' if File.exists?('spec/spec_helper.rb')
rescue ScriptError => e
  puts e.message
  Kernel::exit(1)
end

unless self.respond_to?(:spec)
  load_template('http://github.com/hectoregm/rails-templates/raw/master/methods.rb')
end

# Cucumber gem dependencies
%w{term-ansicolor treetop diff-lcs nokogiri builder}.each do |package|
  gem package, :lib => false, :env => 'test'
end

# Add gem dependencies
gem 'rspec', :version => '= 1.2.4', :lib => false, :env => 'test'
gem 'rspec-rails', :version => '= 1.2.4', :lib => false, :env => 'test'
gem 'webrat', :version => '= 0.4.4', :lib => 'webrat', :env => 'test'
gem 'cucumber', :version => '= 0.3.0', :env => 'test'
gem 'remarkable_rails', :lib => false, :env => 'test'
gem 'spicycode-rcov', :lib => 'rcov', :env => 'test', :source => 'http://gems.github.com'
gem 'bmabey-email_spec', :version => '>= 0.1.3', :lib => 'email_spec', :env => 'test', :source => 'http://gems.github.com'
gem 'sevenwire-forgery', :lib => 'forgery', :env => 'test', :source => 'http://gems.github.com'
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

log 'template', 'Successfully applied BDD template'
