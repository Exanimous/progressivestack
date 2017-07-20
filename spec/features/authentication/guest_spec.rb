# spec/features/authentication/guest_spec.rb
require 'rails_helper'

feature "sign in as user while already a guest: ", js: true do
  Capybara.current_driver = :webkit
  given!(:user) { FactoryGirl.create(:user) }
  given!(:new_user) { FactoryGirl.attributes_for(:user_two) }
  given!(:invalid_user) { FactoryGirl.attributes_for(:invalid_user) }
  given(:new_quotum) { FactoryGirl.attributes_for(:quotum) }
  given(:updated_quotum) { FactoryGirl.attributes_for(:quotum, name: "updated rspec quotum") }

  scenario 'create guest account when creating quotum' do
    expect {

      visit quota_path

      click_link "New Quotum (remote)"

      wait_for_ajax
      expect(page).to have_content('Name')
      expect(page).to have_content('New Quotum')
      fill_in 'Name', with: new_quotum[:name]

      click_button "Create Quotum"

      expect(page).to have_content('Dropdown')
      expect(page).to have_content(new_quotum[:name])
      expect(page).to have_content(Constants::GUEST_DISPLAY_NAME)
      expect(page).to have_selector('.guest-name', count: 1)
      expect(page).to have_content('sign up')
    }.to change(Quotum, :count).by(1)
  end

  scenario 'display guest notification when creating quotum' do

    visit quota_path

    click_link "New Quotum (remote)"

    wait_for_ajax
    fill_in 'Name', with: new_quotum[:name]

    click_button "Create Quotum"
    wait_for_ajax

    expect(page).to have_selector('.notifications-bar')
    expect(page).to have_content('A guest account has been created for you')
  end

end

feature "sign out of guest user", js: true do
  Capybara.current_driver = :webkit
  given(:quotum) { FactoryGirl.attributes_for(:quotum) }

  # simulate creation of guest account
  before(:each) do
    FactoryGirl.create(:quotum)
    visit quota_path
    accept_confirm do
      click_link 'Delete'
      wait_for_ajax
    end
  end
end
