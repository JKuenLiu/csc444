When(/^I go to the homepage$/) do
  visit root_path
end

Given /^I clear cookies$/ do
  Capybara.reset_sessions!
end

Then(/^I should see LNDR$/) do
  expect(page).to have_content("LNDR")
end

When(/^User clicks Log In$/) do
  click_link('Log in')
end

When(/^User types credentials and clicks submit$/) do
  fill_in('Email', :with => 'p@p.com')
  fill_in('Password', :with => 'asdfgh')
  click_button('Log in')
end

Then(/^I should see Log in Header$/) do
  expect(page).to have_content("Log in")
end

Then(/^I should see Log in links$/) do
  expect(page).to have_link("Log in")
end

Then(/^I should see signed in successfully$/) do
  expect(page).to have_content("Signed in successfully.")
end