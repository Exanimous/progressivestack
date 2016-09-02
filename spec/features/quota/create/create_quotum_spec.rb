# spec/features/quota_index_spec.rb
require 'rails_helper'

# feature spec to test:
# new quotum, create, update index display

RSpec.feature "Feature: create quotum: " do
  given!(:quotum) { FactoryGirl.build(:quotum, name: "new rspec quotum") }
  given!(:invalid_quotum) { FactoryGirl.build(:invalid_quotum) }

  # visit via remote link (js)
  # perform create action
  scenario 'create new quotum (remote/js)', js: true do
    Capybara.javascript_driver = :selenium

    expect {
      visit quota_path

      click_link "New Quotum (remote)"

      wait_for_ajax
      expect(page).to have_content('Name')
      expect(page).to have_content('New Quotum')
      fill_in 'Name', with: quotum.name

      click_button "Create Quotum"

      expect(page).to have_selector('.alert-success')
      expect(page).to have_content(quotum.name)
      expect(page).to have_title "Quota index | Progressivestack"
    }.to change(Quotum, :count).by(1)
  end

  # visit via remote link (js)
  # perform create action
  scenario 'create new quotum with invalid input (remote/js)', js: true do
    Capybara.javascript_driver = :selenium

    expect {
      visit quota_path

      click_link "New Quotum (remote)"

      wait_for_ajax
      expect(page).to have_content('Name')
      fill_in 'Name', with: invalid_quotum.name
      click_button "Create Quotum"

      expect(page).to have_selector('.alert-danger')
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content('New Quotum')
      expect(page).to have_title "New quotum | Progressivestack"
    }.to_not change(Quotum, :count)
  end

  # simulate visit link directly via url (html)
  # perform create action
  scenario 'create new quotum via url (html)', js: true do
    Capybara.javascript_driver = :selenium

    expect {

      visit new_quotum_path(format: :html)

      wait_for_ajax
      expect(page).to have_content('Name')
      expect(page).to have_content('New Quotum')
      fill_in 'Name', with: quotum.name

      click_button "Create Quotum"

      expect(page).to have_selector('.alert-success')
      expect(page).to have_content(quotum.name)
      expect(page).to have_title "Quota index | Progressivestack"
    }.to change(Quotum, :count).by(1)
  end

  # simulate visit link directly via url (html)
  # perform create action
  scenario 'create new quotum with invalid input via url (html)', js: true do
    Capybara.javascript_driver = :selenium

    expect {

      visit new_quotum_path(format: :html)

      wait_for_ajax
      expect(page).to have_content('Name')
      fill_in 'Name', with: invalid_quotum.name
      click_button "Create Quotum"

      expect(page).to have_selector('.alert-danger')
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content('New Quotum')
      expect(page).to have_title "New quotum | Progressivestack"
    }.to_not change(Quotum, :count)
  end

  # due to parameterization called on name to generate slug - sometimes slug will be non-unique
  # tests when we create a quotum with valid name and invalid slug due to parameterization
  scenario 'create new quotum with name that creates invalid slug (html)', js: true do
    Capybara.javascript_driver = :selenium

    @quotum = FactoryGirl.create(:quotum, name: "new rspec quotum")

    expect {

      visit new_quotum_path(format: :html)

      wait_for_ajax
      expect(page).to have_content('Name')
      fill_in 'Name', with: 'new rspec & quotum'
      click_button "Create Quotum"

      expect(page).to have_selector('.alert-danger')
      expect(page).to have_content("Name is unavailable")
      expect(page).to have_content('New Quotum')
      expect(page).to have_title "New quotum | Progressivestack"

    }.to_not change(Quotum, :count)
  end
end
