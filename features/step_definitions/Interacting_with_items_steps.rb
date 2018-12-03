When(/^User clicks lend an item$/) do
  click_on('Lend an Item')
end

Then(/^I should see Lend an Item link$/) do
  expect(page).to have_content("Lend an Item")
end


Then(/^I should see lend an item header$/) do
  expect(page).to have_content("New Item")
end


When(/^User fills in create item form and clicks submit$/) do
  fill_in('Name', :with => 'Basketball')
  fill_in('Description', :with => 'it bounces')
  select('Clothing', :from => 'Category')
  fill_in('tags', :with => 'ball, sports')
  click_button('Submit')
end

Then(/^I should new item to exist$/) do
  item = Item.find_by_name("Basketball")
  expect(item.person.fname).to eq("p0")
  expect(item).to be_truthy #Not nil or false
end