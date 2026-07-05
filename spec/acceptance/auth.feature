Feature: Authentication
  Background:
    Given user with "email@example.com" email address and "admin" username exists

  Scenario: sign-in
    When I visit the sign-in page
    And I fill in the sign-in form with email "email@example.com"
    Then I should receive a sign-in code
    When I fill in the sign-in form with code I received on my email address
    Then I should be signed in
