When(/^I go to the homepage$/) do
  visit root_path
end

Then(/^I should see LNDR$/) do
  expect(page).to have_content("LNDR")
end

Given /^I clear cookies$/ do
  Capybara.reset_sessions!
end

When(/^User clicks Log In$/) do
  click_link('Log in')
end

When(/^User clicks sign up$/) do
  click_link('Sign up')
end

When(/^User types login credentials and clicks submit$/) do
  fill_in('Email', :with => 'p@p.com')
  fill_in('Password', :with => 'asdfgh')
  click_button('Log in')
end

When(/^User types sign up credentials and clicks submit$/) do
  fill_in('Email', :with => 'test@test.com')
  fill_in('Password', :with => 'password')
  fill_in('Password confirmation', :with => 'password')
  click_button('Continue')
end

When(/^User fills in personal information and clicks submit$/) do
  fill_in('First Name', :with => 'John')
  fill_in('Last Name', :with => 'Doe')
  fill_in('Street Address', :with => '123 Street Av.')
  fill_in('City', :with => 'Sunnytown')
  fill_in('Province', :with => 'Solarus')
  fill_in('Country', :with => 'Milky Way')
  fill_in('Phone Number', :with => '123-456-7890')
  click_button('Submit')
end



Then(/^I should see Log in Header$/) do
  expect(page).to have_content("Log in")
end

Then(/^I should see Sign up Header$/) do
  expect(page).to have_content("Sign up")
end

Then(/^I should see Log in links$/) do
  expect(page).to have_link("Log in")
end

Then(/^I should see Sign up links$/) do
  expect(page).to have_link("Sign up")
end


Then(/^I should see signed in successfully$/) do
  expect(page).to have_content("Signed in successfully.")
end

Then(/^I should see Personal Information Form$/) do
  expect(page).to have_content("Personal Information")
end

Then(/^I should expect person John Doe to exist$/) do
  person = Person.find_by_fname("John")
  expect(person).to be_truthy #Not nil or false
end