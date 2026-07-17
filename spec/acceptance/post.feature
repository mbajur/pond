Feature: Post
  Background:
    Given user with "admin@example.com" email address and "admin" username exists
    And "@admin" has a premium account
    And "@admin" is signed in

  @js
  Scenario: creating URL post
    When I visit "@admin" profile page
    And I click on the "+ Add" button
    And I click on the "Link" link
    And I fill in "post_url_url" with "https://example.com"
    And I click on the "Save" button
    Then I should see "Post was successfully created" flash message
    When I visit "Inbox" collection by "@admin"
    Then I should see "example.com" connection
    When I click on the "example.com" post thumb
    Then I should see "https://example.com" post page

  @js
  Scenario: creating text post
    When I visit "@admin" profile page
    And I click on the "+ Add" button
    And I click on the "Text" link
    And I fill in "post_text[content]" with "This is a text post"
    And I click on the "Save" button
    Then I should see "Post was successfully created" flash message
    When I visit "Inbox" collection by "@admin"
    Then I should see "This is a text post" connection

  @js
  Scenario: creating image post
    When I visit "@admin" profile page
    And I click on the "+ Add" button
    And I click on the "Image" link
    And I attach "1x1.jpg" file in "post_image_files" input
    And I click on the "Save" button
    Then I should see "Post was successfully created" flash message
    When I visit "Inbox" collection by "@admin"
    Then I should see "1x1.jpg" connection

  @js
  Scenario: updating a URL post
    Given "@admin" has "My Collection" collection
    Given "https://example.com" URL post by "@admin" on "My Collection" collection exists
    When I visit "@admin" profile page
    And I click on the "example.com" post thumb
    And I click on the "…" button
    And I click on the "Edit" link
    And I fill in "Title" with "Changed title"
    And I click on the "Save" button
    Then I should be on a post page with "Changed title" title
    And I should see "Changed title" text

  @js
  Scenario: updating an image post
    Given "@admin" has "My Collection" collection
    Given "1x1.jpg" image post by "@admin" on "My Collection" collection exists
    When I visit "@admin" profile page
    And I click on the "1x1.jpg" post thumb
    And I click on the "…" button
    And I click on the "Edit" link
    And I fill in "Title" with "Changed title"
    And I click on the "Save" button
    Then I should be on a post page with "Changed title" title
    And I should see "Changed title" text

  @js
  Scenario: updating a text post
    Given "@admin" has "My Collection" collection
    Given "This is a text post" text post by "@admin" on "My Collection" collection exists
    When I visit "@admin" profile page
    And I click on the "This is a text post" post thumb
    And I click on the "…" button
    And I click on the "Edit" link
    And I fill in "Title" with "Changed title"
    And I click on the "Save" button
    Then I should be on a post page with "Changed title" title
    And I should see "Changed title" text

  @js
  Scenario: removing a post
    Given "@admin" has "My Collection" collection
    Given "https://example.com" URL post by "@admin" on "My Collection" collection exists
    When I visit "@admin" profile page
    And I click on the "example.com" post thumb
    And I click on the "…" button
    And I click on the "Delete" button
    Then I should not see "example.com" connection
