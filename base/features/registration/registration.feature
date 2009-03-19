Feature: Registration
In order to give the user a full experience
An anonymous user of the system
Must register before using the application

Scenario: Display registration form to anonymous user
Given "hector" is an anonymous user
When I go to the homepage
Then I should see "Register"
When I follow "Register"
Then I should see the registration form

Scenario: Allow an anonymous user to create account
Given "hector" is an anonymous user
When I go to the registration form
And I fill in "login" with "hector"
And I fill in "email" with "hector@mail.com"
And I fill in "password" with "secret"
And I fill in "password confirmation" with "secret"
And I press "Register"
Then I should have a successful registration

Scenario Outline: Not allow an anonymous user to create account with incomplete input
Given "hector" is an anonymous user
When I go to the registration form
And I fill in "login" with "<login>"
And I fill in "email" with "<email>"
And I fill in "password" with "<password>"
And I fill in "password confirmation" with "<password_confirmation>"
And I press "Register"
Then I should have an unsuccessful registration
 
    Examples:
      | login  |      email      | password | password_confirmation |
      |        |                 |          |                       |
      | hector |                 |          |                       |
      | hector | hector@mail.com |          |                       |
      | hector | hector@mail.com |  secret  |                       |
      | hector | hector@mail.com |  secret  |   sec                 |

Scenario: Account must be activated before login is allowed
Given "hector" an unactivated user
When I go to the account page
Then I should not see my account page

Scenario: Send a mail activation at a successful account creation
Given "hector" an unactivated user
And I receive an email
When I open the email
Then I should see "confirm" in the email

Scenario: Activate account using mail activation token
Given "hector" an unactivated user
When I receive an email
And I open the email
Then I should see "confirm" in the email
When I follow "confirm" in the email
Then I should see "Account confirmed!"
And I should see my account page

Scenario: Do not activate account with invalid mail activation token
Given "hector" an unactivated user 
When I go to the confirm page with bad token
Then I should not see my account page

# Scenario: Not allow login of an unactivated user
# Scenario: Allow login of an activated user
