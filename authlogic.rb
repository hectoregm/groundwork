# Authlogic template.
log 'template', 'Applying authlogic template'

begin
  raise ScriptError, "This application is already using authlogic." if File.exists?('spec/spec_helpers/authentication_spec_helper.rb')
rescue ScriptError => e
  puts e.message
  Kernel::exit(1)
end

unless self.respond_to?(:model)
  @stand_alone = true
  load_template('http://github.com/hectoregm/groundwork/raw/master/methods.rb')
end

# Add gem dependencies
gem 'haml' if templating_engine == "haml"
gem 'rdiscount'
gem 'justinfrench-formtastic', :lib => 'formtastic', :source  => 'http://gems.github.com'
gem 'authlogic', :version => "= 2.0.9"

# Install gems
rake 'gems:install', :sudo => true

# Haml setup
run("haml --rails .") if templating_engine == "haml"

# Initializer for action_mailer configuration
initializer "action_mailer.rb", get_source("config/initializers/action_mailer.rb")

# Set I18n load path
environment(%q|config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]|)

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
environment('config.active_record.observers = :user_observer')

# Get controllers
controller "application_controller.rb"
controller "user_sessions_controller.rb"
controller "users_controller.rb"
controller "password_resets_controller.rb"
controller 'home_controller.rb'

# Get views
view "users", "new.html.#{templating_engine}"
view "users", "edit.html.#{templating_engine}"
view 'users', "_semantic_form.html.#{templating_engine}"
view "users", "show.html.#{templating_engine}"
view "user_sessions", "new.html.#{templating_engine}"
view "user_mailer", "activation.text.html.#{templating_engine}"
view "user_mailer", "reset_password_instructions.text.html.#{templating_engine}"
view "user_mailer", "signup_notification.text.html.#{templating_engine}"
view "password_resets", "new.html.#{templating_engine}"
view "password_resets", "edit.html.#{templating_engine}"
view 'home', "index.html.#{templating_engine}"
view 'home', "index.es.html.#{templating_engine}"

#Get helpers
helper 'layout_helper.rb'
helper "#{templating_engine}_helper.rb"

# Modify layouts
layout "application.html.#{templating_engine}"
layout "single_column.html.#{templating_engine}"

# Get stylesheets
if templating_engine == "haml"
  sass 'base.sass'
  sass 'behaviors.sass'
  sass 'colors.sass'
  sass 'style.sass'
else
  stylesheet 'base.css'
  stylesheet 'style.css'
end


if requested? :bdd
  if templating_engine == "haml"
    haml_setup = <<-EOF.gsub(/^( ){4}/, '')
      config.prepend_before(:all, :type => :helper) do
        helper.extend Haml
        helper.extend Haml::Helpers
        helper.send :init_haml_helpers
      end
    end
    EOF
    gsub_file('spec/spec_helper.rb', /end\n$/, haml_setup)
  end

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
  spec 'helpers/layout_helper_spec.rb'
  spec "helpers/#{templating_engine}_helper_spec.rb"
end

# Get i18n files
cp_r 'config/locales', 'config'

# Replace APP with the app name.
gsub_file("app/views/layouts/single_column.html.#{templating_engine}", /APP/, app_name)
gsub_file("app/views/layouts/application.html.#{templating_engine}", /APP/, app_name)
gsub_file('app/models/user_mailer.rb', /APP/, app_name)
gsub_file('config/locales/views/user_mailer/en.yml', /APP/, app_name)
gsub_file('config/locales/views/user_mailer/en.yml', /APP/, app_name)
gsub_file('config/locales/views/user_mailer/es.yml', /APP/, app_name)

if @stand_alone
  rm 'public/index.html'
  rake 'db:migrate'
  rake 'db:test:load'
end

# Authlogic template.
log 'template', 'Successfully applied authlogic template'
