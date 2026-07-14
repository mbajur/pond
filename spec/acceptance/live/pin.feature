Feature: Live / Pin
  Background:
    Given user with "admin@example.com" email address and "admin" username exists
    And "@admin" has "Admin Collection" collection
    And "https://example.com" URL post by "@admin" on "Admin Collection" collection exists
    And "@admin" is signed in

  @js
  Scenario: pinned post gets updated when viewing collections list
    When I visit "@admin" profile page
    Then I should see "example.com" connection
    When "https://example.com" pinned URL post is updated with "Updated Title"
    Then I should see "Updated Title" connection

  @js
  Scenario: pinned post gets updated when viewing single collection page
    When I visit "@admin" profile page
    Then I should see "example.com" connection
    When I click on the "Admin Collection" link
    Then I should see "example.com" connection
    When "https://example.com" pinned URL post is updated with "Updated Title"
    Then I should see "Updated Title" connection
