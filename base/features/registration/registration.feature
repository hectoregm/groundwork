Feature: Registration
  As a anonymous user
  I want be able to register
  So that can be productive and be cool

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
    And I fill in "confirmation" with "secret"
    And I press "Register"
    Then I should have a successful registration

  Scenario Outline: Not allow an anonymous user to create account with incomplete input
    Given "hector" is an anonymous user
    When I go to the registration form
    And I fill in "login" with "<login>"
    And I fill in "email" with "<email>"
    And I fill in "password" with "<password>"
    And I fill in "confirmation" with "<password_confirmation>"
    And I press "Register"
    Then I should have an unsuccessful registration
 
  Examples: Additional input needed
    | login  |      email      | password | password_confirmation |
    |        |                 |          |                       |
    | hector |                 |          |                       |
    | hector | hector@mail.com |          |                       |
    | hector | hector@mail.com |  secret  |                       |

  Examples: Bad password and confirmation combinations
    | login  |      email      | password | password_confirmation |
    | hector | hector@mail.com |          |                       |
    | hector | hector@mail.com |  secret  |                       |
    | hector | hector@mail.com |          |        secret         |
    | hector | hector@mail.com |  secret  |     othersecret       |

  Scenario: Send a mail activation at a successful account creation
    Given "hector" an unconfirmed user
    And I receive an email
    When I open the email
    Then I should see "confirm" in the email

  Scenario: Confirm account using mail activation token
    Given "hector" an unconfirmed user
    When I receive an email
    And I open the email
    Then I should see "confirm" in the email
    When I follow "confirm" in the email
    Then I should see "Account confirmed!"
    And I should be logged in

  Scenario: Do not confirm an account with invalid mail activation token
    Given "hector" an unconfirmed user
    When I go to the confirm page with bad token
    Then I should not be logged in

  Scenario: Send a welcome mail when user confirms account
    Given "hector" an unconfirmed user
    And I receive an email
    And I open the email
    And I should see "confirm" in the email
    When I follow "confirm" in the email
    Then I should be logged in
    And I should have 2 emails
    Then I open the most recent email
    And I should see "Welcome" in the subject
