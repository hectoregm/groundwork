# Authlogic template.
log 'template', 'Applying authlogic template'

# Add plugins.
# plugin 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git', :submodule => true

# Install gems
gem 'haml'
gem 'rdiscount'
gem 'authlogic', :version => "= 2.0.9"
gem 'justinfrench-formtastic', :lib => 'formtastic', :source  => 'http://gems.github.com'

########## Dependecies Install ##########
rake 'gems:install', :sudo => true

########## Application Setup ##########
run("haml --rails .")

# Initializer for action_mailer configuration
initializer "action_mailer.rb", get_source("config/initializers/action_mailer.rb")

# Set I18n load path
environment(%q|config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]|)

# Add ruby-debug to development environment (ruby18 only)
environment("require 'ruby-debug' if RUBY_VERSION < '1.9'", :env => 'development')

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
environment('config.active_record.observers = :user_observer')

# Get controllers
controller "application_controller.rb"
controller "user_sessions_controller.rb"
controller "users_controller.rb"
controller "password_resets_controller.rb"
controller 'home_controller.rb'

# Get views
view "users", "new.html.haml"
view "users", "edit.html.haml"
view 'users', '_semantic_form.html.haml'
view "users", "show.html.haml"
view "user_sessions", "new.html.haml"
view "user_mailer", "activation.text.html.haml"
view "user_mailer", "reset_password_instructions.text.html.haml"
view "user_mailer", "signup_notification.text.html.haml"
view "password_resets", "new.html.haml"
view "password_resets", "edit.html.haml"
view 'home', 'index.html.haml'
view 'home', 'index.es.html.haml'

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
spec 'helpers/layout_helper_spec.rb'

# Get i18n files
cp_r 'config/locales', 'config'

# Replace APP with the app name.
gsub_file('app/views/layouts/single_column.html.haml', /APP/, app_name)
gsub_file('app/views/layouts/application.html.haml', /APP/, app_name)
gsub_file('app/models/user_mailer.rb', /APP/, app_name)
gsub_file('config/locales/views/user_mailer/en.yml', /APP/, app_name)
gsub_file('config/locales/views/user_mailer/en.yml', /APP/, app_name)
gsub_file('config/locales/views/user_mailer/es.yml', /APP/, app_name)

# Authlogic template.
log 'template', 'Successfully applied authlogic template'
