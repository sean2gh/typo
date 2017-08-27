Feature: Merge Articles
  As a blog administrator of a blog with multiple authors
  In order to combine blog articles by multiple authors on the same topic
  I want to be able to merge two articles into one, preserving both content.

  #1. A non-admin cannot merge articles.
  #2. When articles are merged, the merged article should contain the text of both previous articles.
  #3. When articles are merged, the merged article should have one author (either one of the authors of the original article).
  #4. Comments on each of the two original articles need to all carry over and point to the new, merged article.
  #5. The title of the new article should be the title from either one of the merged articles.
Background: the blog exists, articles have been added to database
    Given the following articles exist:
    | title        | author   | body                            | published |
    | First Post   | User1    | The text in the first post.     | true      |
    | Second Post  | User2    | The text in the second post.    | true      |
    
    And the following users exist:
    | login     | password | email          | name        | profile_id |
    | admin     | 1234     | admin@blog.com | Admin       | 1          |
    | user      | 1234     | user@blog.com  | UserX       | 2          |

  #1. A non-admin cannot merge articles:
  Scenario: I am a non-admin so I cannot merge articles 
    Given I am logged into the admin panel as "UserX"
    And I visit the the edit page for "A first post"
    Then I should not see "Merge Articles"

  #2. An admin can merge articles using  a form on that article’s edit 
  # page that allows an administrator to enter in the ID of another 
  # article to merge the current article with. 
  # an    
  Scenario: I am an admin and want to be able to merge two articles
    Given I am logged into the admin panel as "Admin"
    When I am on the show page for article id "1"
    Then I should see "Merge"


  Scenario: Merged article should contain text of both articles
    Given I am logged into the admin panel as "admin"
    And I visit the the edit page for "A first post"
    And I attempt to merge with "A second post"
    And I revisit the the edit page for "A first post"
    Then I should see "The text in the first blog post.Followed by the text in a similar blog post."

  # Scenario: Merged article should contain comments of both articles
  #   Given that the first article contains comments with id: 1, 2
  #   And the second article contains comments with id: 3, 4, 5
  #   And the articles are merged
  #   Then the merged articles should contain comments with id: 1, 2, 3, 4, 5

  #  Scenario: Merged article should have title of either article
  #    Given that the first article has title "First Article"
  #    Given that the second article has title "Second Article"
  #    And the articles are merged
  #    Then the merged article should have the title "First Article" or "Second Article"
  #
  #  Scenario: Merged article should have author of either article
  #    Given that the first article has author "First Author"
  #    Given that the second article has author "Author Second"
  #    And the articles are merged
  #    Then the merged article should have the title "First Author" or "Author Second"