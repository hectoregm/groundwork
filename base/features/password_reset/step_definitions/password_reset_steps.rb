Then /^I should see a reset password form$/ do
  response.should contain('Forgot Password')
  response.should contain('Email')
end
