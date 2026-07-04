# Simple tests just to verify this page works fine
Feature: Search
  Background:
    Given user with "admin@example.com" email address and "admin" username exists
    Given user with "user@example.com" email address and "user" username exists
    And "@user" has "User collection" collection
    And "https://example.com" URL post by "@user" on "User collection" collection exists
    And "@admin" is signed in

  Scenario: visiting search page
    When I visit search page
    Then I should see "Search" text
    And I should see "User collection" link
    And I should see "example.com" text
