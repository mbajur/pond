Feature: Feed
  Background:
    Given user with "admin@example.com" email address and "admin" username exists
    Given user with "user@example.com" email address and "user" username exists
    Given user with "user2@example.com" email address and "user2" username exists
    Given "@user" has "User collection" collection
    Given "@user2" has "User2 collection" collection
    Given "https://example.com" URL post is created by "@user" on "User collection" collection
    Given "https://example2.com" URL post is created by "@user2" on "User2 collection" collection
    And "@admin" is signed in

  Scenario: following and unfollowing users
    When I visit feed page
    Then I should not see "User1 collection" in the feed
    Then I should not see "User2 collection" in the feed
    When I visit "@user" profile page
    And I click on the follow button
    Then I should see unfollow button
    When I visit feed page
    Then I should see "User collection" in the feed
    Then I should not see "User2 collection" in the feed
    When I visit "@user" profile page
    And I click on the unfollow button
    When I visit feed page
    Then I should not see "User collection" in the feed
    Then I should not see "User2 collection" in the feed
