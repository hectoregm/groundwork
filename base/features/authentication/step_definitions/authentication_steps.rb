When /^I register$/ do
  When 'I follow "Register"'
  When 'I fill in the registration form'
end

Then /^I should be logged in$/ do
  Then 'I should see "Registration completed!"'
end

Given /^I am a user not logged in$/ do
  User.make(:login => 'Mono', :password => 'newton', :password_confirmation => 'newton')
end
