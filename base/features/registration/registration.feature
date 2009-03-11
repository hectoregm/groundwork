Feature: User registration to APP
In order for user to use APP
As an unregistered user
I want to create an account

Scenario: Display a register form for a new user
Given I am a new user
When I go to the homepage
Then I should see "Register"
When I follow "Register"
Then I should see a registration form

Scenario: Allow a new user to be registered
Given I am a new user
When I go to the homepage
And I follow "Register"
And I fill in the registration form
Then I should have a successful registration