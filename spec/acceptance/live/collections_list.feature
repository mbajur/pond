Feature: Live / Collections list
  Background:
    Given user with "admin@example.com" email address and "admin" username exists
    And "@admin" has "Admin Collection" collection
    And "@admin" is signed in

  @js
  Scenario: adding post while being on collections list screen
    When I visit "@admin" profile page
    And I click on the "+ Add" button
    And I click on the "Link" link
    And I fill in "post_url_url" with "https://example.com"
    And I click on the "Save" button
    Then I should see "Post was successfully created" flash message
    And I should see "example.com" connection
