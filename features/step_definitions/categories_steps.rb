# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  @movies_table = movies_table
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end


##** steps for sort_movie_list.feature:
# Make sure that one string (regexp) occurs before or after another one
#   on the same page
When /I click "(.*)"/ do |clicked|
  case clicked
  when "Movie Title"
    click_link("Movie Title") #the text in between the <a></a> tags.
    #click_link("title_header") #the id of the a href element.
  when "Release Date"
    click_link("release_date_header") 
  end 
end 

Then /I should see "(.*)" before "(.*)"/ do |movie1, movie2|
  #  ensure that that movie1 occurs before movie2.
  #  page.body is the entire content of the page as a string.
  movie1_index = page.body.index(movie1)
  movie2_index = page.body.index(movie2)
  if !(movie1_index < movie2_index)
    fail "the sort has failed"
  end 
end

And /"(.*)" should be "(.*)"/ do |sortedby, class_selector|
  page.should have_css("table#movies th.#{class_selector}")
  #find(:xpath, "//td[@id='#{cell_id}']")
  results = find("table#movies th.#{class_selector}").native.inner_html
  if not results.include? sortedby
    fail
  end
end

##** steps for filter_movie_list.feature:
# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"
When /I (un)?check the following ratings: "(.*)"/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(',')
  #uncheck = "" or "un" for unchecked. 
  #rating_list: the ratings to be checked or unchecked in the format G,PG
  ratings.each do |rating|
    if uncheck == "un"
      uncheck("ratings[#{rating.to_s}]")
    else
      check("ratings[#{rating.to_s}]")
    end 
  end
end

When /I press "submit" on the ratings filters/ do
  click_button("Refresh")
end

Then /I should only see movies rated: "(.*)"/ do |ratings|
  ratings = ratings.split(',')
  @movies_table.hashes.each do |movie|
    if ratings.include? movie["rating"]  
      if !page.should have_content(movie["title"])
        fail "Filtered page does not have the movies it should"
      end
    else
      if page.has_content?(movie["title"])
        fail "Filtered page has movies that it should not"
      end
    end 
  end 
end 

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  num_movies = @movies_table.hashes.size 
  #puts page.all('table#movies tbody tr').count
  page.all('table#movies tbody tr').count.should == num_movies
end
