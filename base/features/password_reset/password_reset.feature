Feature: Password Reset
As a user that forgot his password
I want to reset my password
So I can continue using the site

Scenario: Display a reset password form
Given "hector" is an anonymous user
When I go to the reset password page
Then I should see a reset password form

Scenario: Send a reset instructions email if given a valid email
Given "hector" a confirmed user
When I go to the reset password page
And I fill in "email" with "hector@mail.com"
And I press "Reset Password"
Then I receive an email
And I open the email
And I should see "reset" in the email

Scenario: Do not send a reset instructions email if given an invalid email
Given "hector" a confirmed user
When I go to the reset password page
And I fill in "email" with "unknown@mail.com"
And I press "Reset Password"
Then "hector@mail.com" should not receive an email
And I should see "No user was found"

Scenario: Display change password form with valid token
Given "hector" a user that opened his reset password email
When I follow "reset" in the email
Then I should see a password modification form

Scenario: Not display change password form with invalid token
Given "hector" a user that opened his reset password email
When I go to the change password form with bad token
Then I should not see a change password form

Scenario: Update password and log in user with valid input
Given "hector" a user that opened his reset password email
And I follow "reset" in the email
And I see a password modification form
And I fill in "password" with "newsecret"
And I fill in "password confirmation" with "newsecret"
When I press "Update Password"
Then I should see my account page
And I should see "Password successfully updated"

Scenario Outline: Don't update password and log in user with invalid input
Given "hector" a user that opened his reset password email
And I follow "reset" in the email
And I see a password modification form
And I fill in "password" with "<password>"
And I fill in "password confirmation" with "<password_confirmation>"
When I press "Update Password"
Then I should not see my account page
And I should not see "Password successfully updated"
And I should see a password modification form

    Examples:
      |  password  |  password_confirmation  |
      |  newsecret |                         |
      |            |       newsecret         |
      |            |                         |
      |  newsecret |         secret          |
