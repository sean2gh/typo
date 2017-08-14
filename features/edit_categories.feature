Feature: Create and Edit Categories
  As a blog administrator
  In order to categorise my thoughts and posts
  I want to be able to create and edit the categories of my blog posts.

  Background:
    Given the blog is set up
    And I am logged into the admin panel

  Scenario: Successfully create a category
    When I am on the home page
    And I click on "Categories"
    Then I should see "Description"
    
  Scenario: Edit existing category
    When I am on the home page
    And I click on "Categories"
    Then I should see "Description"    