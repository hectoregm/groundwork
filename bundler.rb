require 'erb'
log 'template', 'Applying Bundler template'

begin
  raise ScriptError, 'This application already uses Bundler' if File.exists?('Gemfile')
rescue ScriptError => e
  puts e.message
  Kernel::exit(1)
end

unless self.respond_to? :spec
  load_template('http://github.com/hectoregm/groundwork/raw/master/methods.rb')
end

root_config "Gemfile"

def add_testing?
  true
end
template = <<-EOF.gsub(/^  /, '')
source :gemcutter

gem 'rails', '2.3.8', :require => nil
<% if FEATURES.include? :authlogic %>
gem 'haml'
gem 'rdiscount'
gem 'formtastic'
gem 'authlogic', '= 2.0.11'
gem 'ruby-debug'
<% end %>

<% if FEATURES.include? :bdd %>
group :test do
  gem 'rspec', '= 1.2.4'
  gem 'rspec-rails', '= 1.2.4'
  gem 'webrat', '= 0.4.4'
  gem 'cucumber', '= 0.3.1'
  gem 'remarkable_rails'
  gem 'rcov'
  gem 'email_spec'
  gem 'forgery'
  gem 'machinist'
  gem 'sqlite3-ruby'
end
<% end %>
EOF

erb_template = ERB.new template, nil, "%>"
file 'Gemfile', erb_template.result(binding)

run "bundle install"
