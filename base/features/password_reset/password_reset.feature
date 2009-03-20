Feature: Password Reset
In order to continue the use of his account
A forgetful user of the system
Can request a password reset for his account

Scenario: Display a reset password form
Given "hector" is an anonymous user
When I go to the reset password page
Then I should see a reset password form
