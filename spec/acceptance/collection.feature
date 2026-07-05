Feature: Collection
  Background:
    Given user with "admin@example.com" email address and "admin" username exists
    And "@admin" is signed in

  @js
  Scenario: creating collection
    When I visit "@admin" profile page
    And I click on the "Add Collection" button
    And I fill in "collection_name" with "My Collection"
    And I check "collection_private" checkbox
    And I click on the "Create collection" button
    Then I should see "My Collection" in page header
    Then I should see "private" in page header

  @js
  Scenario: editing collection
    Given "@admin" has "My Collection" collection
    When I visit "@admin" profile page
    And I click on the "My Collection" link
    And I click on the "Edit Collection" button
    And I fill in "collection_name" with "My Collection Edited"
    And I check "collection_private" checkbox
    And I click on the "Update collection" button
    Then I should see "My Collection Edited" in page header
    Then I should see "private" in page header

  Scenario: visiting other user private collection
    Given user with "user@example.com" email address and "user" username exists
    And "@user" has private "User collection" collection
    When I visit "@user" profile page
    Then I should not see "User collection" text
    And I visit "User collection" collection by "@user"
    # This is a temporary solution, we should handle this case better in the future:
    Then I should see "ActiveRecord::RecordNotFound" text
