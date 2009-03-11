Given /^I am a new user$/ do
  User.new
end

Then /^I should see a registration form$/ do
  response.should contain('Login')
  response.should contain('Password')
  response.should contain('Password confirmation')
end

When /^I fill in the registration form$/ do
  pass = BasicForgery.password
  When "I fill in \"login\" with \"#{InternetForgery.user_name}\""
  When "I fill in \"password\" with \"#{pass}\""
  When "I fill in \"password confirmation\" with \"#{pass}\""
  When 'I press "Register"'
end

Then /^I should have a successful registration$/ do
  When 'I should see "Registration completed!"'
end
