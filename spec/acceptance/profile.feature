Feature: Profile
  Background:
    Given user with "admin@example.com" email address and "admin" username exists
    And "@admin" is signed in

  @js
  Scenario: updating profile settings
    When I visit "@admin" profile page
    And I click on the "Edit profile" button
    And I fill in "Display name" with "Changed Name"
    And I fill in "Description" with "Changed Bio"
    And I check "user_private" checkbox
    And I click on the "Update profile" button
    Then I should see "Changed Bio" in page header
    Then I should see "private" in page header

  Scenario: visiting other user profile as logged in user
    Given user with "user@example.com" email address and "user" username exists
    When I visit "@user" profile page
    Then I should not see "Edit profile" button
