Feature: Authentication
In order for a given user begins to use APP
As an registered user
I want to be log in

Scenario: Logs user after registration.
Given I am a new user
When I go to the homepage
And I register
Then I should be logged in


Scenario: Logs user with correct authentication credentials
Given I am a user not logged in
When I go to the homepage
And I follow "Log in"
And I fill in "login" with "Mono"
And I fill in "password" with "newton"
And I press "Login"
Then I should see "Login successful!"