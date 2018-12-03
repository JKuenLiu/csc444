# feature/hello_lndr.feature

Feature: Logging In
  As a product manager
  I want to see that a user can log in

  Scenario:
    Given I clear cookies
    When I go to the homepage
    Then I should see Log in links

  Scenario:
    Given I clear cookies
    And I go to the homepage
    When User clicks Log In
    Then I should see Log in Header

  Scenario:
    Given I clear cookies
    And I go to the homepage
    And User clicks Log In
    When User types login credentials and clicks submit
    Then I should see signed in successfully

    