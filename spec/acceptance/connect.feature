Feature: Connect
  Background:
    Given user with "admin@example.com" email address and "admin" username exists
    And user with "user@example.com" email address and "user" username exists
    And "@admin" has "Admin Collection" collection
    And "@user" has "User Collection" collection
    And "@admin" is signed in

  @js
  Scenario: connecting collection
    When I visit "@user" profile page
    And I click on the "User Collection" link
    And I click on the "Connect" button
    And I select "Admin Collection" from "pin_collection_id" select box
    And I click on the "Save" button
    Then I should see "Pin connected to Admin Collection" flash message
    And I visit "@admin" profile page
    And I click on the "Admin Collection" link
    Then I should see "User Collection" text

  @js
  Scenario: connecting post from pin
    Given "https://example.com" URL post by "@user" on "User Collection" collection exists
    When I visit "@user" profile page
    And I click on the "User Collection" link
    And I click "Connect" button within "https://example.com" post connection
    And I select "Admin Collection" from "pin_collection_id" select box
    And I click on the "Save" button
    Then I should see "Pin connected to Admin Collection" flash message
    And I visit "@admin" profile page
    And I click on the "Admin Collection" link
    Then I should see "example.com" post connection

  @js
  Scenario: connecting post from post page
    Given "https://example.com" URL post by "@user" on "User Collection" collection exists
    When I visit "@user" profile page
    And I click on the "User Collection" link
    And I click on the "https://example.com" post thumb
    Then I should see "https://example.com" post page
    And I click on the "Connect" button
    And I select "Admin Collection" from "pin_collection_id" select box
    And I click on the "Save" button
    Then I should see "Pin connected to Admin Collection" flash message
    And I visit "@admin" profile page
    And I click on the "Admin Collection" link
    Then I should see "example.com" post connection
