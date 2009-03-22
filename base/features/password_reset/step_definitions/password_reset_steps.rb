Given /"(.*)" a user that opened his reset password email/ do |name|
  Given "\"#{name}\" a confirmed user"
  And "I go to the reset password page"
  And "I fill in \"email\" with \"#{name}@mail.com\""
  And "I press \"Reset Password\""
  When "\I receive an email"
  And "I open the email"
  Then "I should see \"reset\" in the email"
  #And "I follow \"reset\" in the email"
end

Then /^I (?:should )?see a reset password form$/ do
  response.should contain('Forgot Password')
  response.should contain('Email')
end

Then /^I (?:should )?see a password modification form$/ do
  response.should contain('Change Password')
  response.should contain('Password')
  response.should contain('Password confirmation')
end

Then /^I should not see a change password form$/ do
  response.should_not contain('Change Password')
end
