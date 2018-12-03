# feature/hello_lndr.feature

Feature: Signing up
  As a product manager
  I want to see that a user can sign up.

  Scenario:
    Given I clear cookies
    When I go to the homepage
    Then I should see Sign up links

  Scenario:
    Given I clear cookies
    And I go to the homepage
    When User clicks sign up
    Then I should see Sign up Header

  Scenario:
    Given I clear cookies
    And I go to the homepage
    And User clicks sign up
    When User types sign up credentials and clicks submit
    Then I should see Personal Information Form

  Scenario:
    Given I clear cookies
    And I go to the homepage
    And User clicks sign up
    And User types sign up credentials and clicks submit
    When User fills in personal information and clicks submit
    Then I should see Lend an Item link
    #Then I should expect person John Doe to exist

    