Then /^I should see a login form$/ do
  response.should contain("Login")
  response.should contain("Password")
  response.should contain("Remember me")
end

Given /^"(.*)" a logged in user$/ do |name|
  Given "\"#{name}\" a confirmed user"
  When "I fill in \"login\" with \"hector\""
  And "I fill in \"password\" with \"secret\""
  And "I press \"Login\""
  Then "I should see my account page"
end
