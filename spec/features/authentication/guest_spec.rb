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

  scenario 'create guest account when deleting quotum' do
    FactoryGirl.create(:quotum)
    expect {
      visit quota_path
      accept_confirm do
        click_link 'Delete'
        wait_for_ajax
      end
      expect(page).to have_content('Dropdown')
      expect(page).to have_content(Constants::GUEST_DISPLAY_NAME)
      expect(page).to have_selector('.guest-name', count: 1)
      expect(page).to have_content('sign up')
    }.to change(Quotum, :count).by(-1)
  end

  scenario 'display guest notification when deleting quotum' do
    FactoryGirl.create(:quotum)

    visit quota_path
    accept_confirm do
      click_link 'Delete'
      wait_for_ajax
    end
    expect(page).to have_selector('.notifications-bar')
    expect(page).to have_content('A guest account has been created for you')
  end

  scenario 'create guest account when updating quotum' do
    quotum = FactoryGirl.create(:quotum)
    visit quota_path

    click_link "Edit"

    wait_for_ajax
    expect(page).to have_content('Name')
    expect(page).to have_content(quotum.name)
    fill_in 'Name', with: updated_quotum[:name]

    click_button "Update Quotum"

    expect(page).to have_content('Dropdown')
    expect(page).to have_content(updated_quotum[:name])
    expect(page).to have_content(Constants::GUEST_DISPLAY_NAME)
    expect(page).to have_selector('.guest-name', count: 1)
    expect(page).to have_content('sign up')
  end

  scenario 'display guest notification when updating quotum' do
    FactoryGirl.create(:quotum)
    visit quota_path

    click_link "Edit"

    wait_for_ajax
    fill_in 'Name', with: updated_quotum[:name]

    click_button "Update Quotum"
    wait_for_ajax

    expect(page).to have_selector('.notifications-bar')
    expect(page).to have_content('A guest account has been created for you')
  end

  scenario 'create guest account when updating quotum (repeat once)' do
    quotum = FactoryGirl.create(:quotum)
    visit quota_path

    expect {
      click_link "Edit"

      wait_for_ajax
      expect(page).to have_content('Name')
      expect(page).to have_content(quotum.name)
      fill_in 'Name', with: updated_quotum[:name]

      click_button "Update Quotum"

      wait_for_ajax

      expect(page).to have_content(updated_quotum[:name])
      expect(page).to have_content(Constants::GUEST_DISPLAY_NAME)
      expect(page).to have_selector('.guest-name', count: 1)

      click_link "Edit"

      wait_for_ajax
      expect(page).to have_content('Name')
      expect(page).to have_content(updated_quotum[:name])
      fill_in 'Name', with: updated_quotum[:name]

      click_button "Update Quotum"

      wait_for_ajax

      expect(page).to have_content('Dropdown')
      expect(page).to have_content(updated_quotum[:name])
      expect(page).to have_content(Constants::GUEST_DISPLAY_NAME)
      expect(page).to have_selector('.guest-name', count: 1)
      expect(page).to have_content('sign up')
    }.to change(User.guests, :count).by(1)
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

  scenario 'delete guest session (sign_out)' do
    expect {
      visit quota_path

      find('.user-guest-menu', match: :first).click
      accept_confirm do
        click_link "delete guest account"
        wait_for_ajax
      end

      expect(page).to have_selector('.alert-info')
      expect(current_path).to eq '/'
      expect(page).to have_content('Dropdown')
      expect(page).to have_content('sign in')
      expect(page).to have_content('sign up')

    }.to change(User.guests, :count).by(-1)
  end
end
