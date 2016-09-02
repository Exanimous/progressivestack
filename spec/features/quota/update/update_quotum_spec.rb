# spec/features/quota_index_spec.rb
require 'rails_helper'

# feature spec to test:
# new quotum, create, update index display

RSpec.feature "Feature: update quotum: " do
  #before :each do
  #  @quotum = FactoryGirl.create(:quotum, name: "Feature #update quotum")
  #end
  given(:new_quotum) { FactoryGirl.build(:quotum, name: "updated rspec quotum") }
  given(:invalid_quotum) { FactoryGirl.build(:invalid_quotum) }
  before :each do
    @quotum = FactoryGirl.create(:quotum, name: "update rspec quotum")
  end


  # visit and update via remote link (js)
  # perform update action
  scenario 'update quotum (remote/js)', js: true do
    Capybara.javascript_driver = :selenium

    visit quota_path

    click_link "Edit"

    wait_for_ajax

    expect(page).to have_content('Name')
    expect(page).to have_content("Editing #{@quotum.name}")

    fill_in 'Name', with: new_quotum.name

    click_button "Update Quotum"

    expect(page).to have_selector('.alert-success')
    expect(page).to have_content(new_quotum.name)
    expect(page).to have_title "Quota index | Progressivestack"
    expect(@quotum.name).to_not eq(new_quotum.name)
  end

  # visit via remote link (js)
  # perform update action
  scenario 'update quotum with invalid input (remote/js)', js: true do
    Capybara.javascript_driver = :selenium

    visit quota_path

    click_link "Edit"

    wait_for_ajax

    expect(page).to have_content('Name')
    expect(page).to have_content("Editing #{@quotum.name}")

    fill_in 'Name', with: invalid_quotum.name

    click_button "Update Quotum"

    expect(page).to have_selector('.alert-danger')
    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Editing #{@quotum.name}")
    expect(page).to have_title "Editing #{@quotum.name} | Progressivestack"
    expect(@quotum.name).to eq("update rspec quotum")
  end

  # simulate visit and update via url (html)
  # perform update action
  scenario 'update quotum via url (html)', js: true do
    Capybara.javascript_driver = :selenium
    visit edit_quotum_path(@quotum)

    expect(page).to have_content("Editing #{@quotum.name}")
    fill_in 'Name', with: new_quotum.name

    click_button "Update Quotum"

    expect(page).to have_selector('.alert-success')
    expect(page).to have_content(new_quotum.name)
    expect(page).to have_title "Quota index | Progressivestack"
    expect(@quotum.name).to_not eq(new_quotum.name)
  end

  # simulate visit and update via url (html)
  # perform update action
  scenario 'update quotum with invalid input via url (html)', js: true do
    Capybara.javascript_driver = :selenium
    visit edit_quotum_path(@quotum)

    expect(page).to have_content("Editing #{@quotum.name}")
    fill_in 'Name', with: invalid_quotum.name

    click_button "Update Quotum"

    expect(page).to have_selector('.alert-danger')
    expect(page).to have_content("Name can't be blank")
    expect(@quotum.name).to eq("update rspec quotum")
    expect(page).to have_title "Editing #{@quotum.name} | Progressivestack"
    expect(page).to have_content("Editing #{@quotum.name}")
  end

end
