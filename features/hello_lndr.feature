# feature/hello_lndr.feature
Feature: Hello LNDR
  As a product manager
  I want to see that the homepage opens

  Scenario: User sees the welcome message
    When I go to the homepage
    Then I should see LNDR
