# feature/hello_lndr.feature

Feature: Creating Items
  As a product manager
  I want to see that a user can create items that are borrowable

  Scenario:
    Given I go to the homepage
    And User clicks Log In
    And User types login credentials and clicks submit
    When User clicks lend an item
    Then I should see lend an item header

  Scenario:
    Given I clear cookies
    And I go to the homepage
    And User clicks Log In
    And User types login credentials and clicks submit
    And User clicks lend an item
    When User fills in create item form and clicks submit
    Then I should new item to exist





    