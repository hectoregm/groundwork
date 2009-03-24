# Email settings
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.raise_delivery_errors = false

if RAILS_ENV == "production"
  ActionMailer::Base.default_url_options[:host] = 'www.domain.com'
  ActionMailer::Base.perform_deliveries = true

  ActionMailer::Base.smtp_settings = {
    :address => "localhost",
    :port => 25,
    :domain => "domain.com"
  }
end

if RAILS_ENV == "development"
  ActionMailer::Base.default_url_options[:host] = 'www.localhost.com'
  ActionMailer::Base.perform_deliveries = false

  ActionMailer::Base.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => 'domain.net',
    :authentication => :plain,
    :user_name => "user_name@gmail.com",
    :password => "user_password"
  }

end

if RAILS_ENV == "test"
  ActionMailer::Base.default_url_options[:host] = 'www.example.com'
  ActionMailer::Base.delivery_method = :test
end
