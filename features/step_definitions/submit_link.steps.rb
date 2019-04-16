When("create a user with username {string} and pass {string}") do |string, string2|
  
  visit "/users/new"
  
  sleep 3
  
  fill_in "user_username", :with => string
  
  fill_in "user_password", :with => string2
  
  click_button("Register")
  
  sleep 3
  
end

When("create a link with title {string} url {string} description {string}") do |string, string2, string3|
  
  visit "/links/new"
  
  sleep 3
  
  fill_in "link_title", :with => string
  
  fill_in "link_url", :with => string2
  
  fill_in "link_description", :with => string3
  
  click_button("submit")
  
  sleep 5
  
   
end


Then("logout") do
  click_link("logout")
end

When("vote for the last published link") do
  click_link("upvote (0)")
end

When("make a comment {string}") do |string|
  click_link("0 comments")
  fill_in "comment_body", :with => string
  click_button("add comment")
  sleep 5
end