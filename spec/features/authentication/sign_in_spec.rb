# spec/features/authentication/sign_in_spec.rb
require 'rails_helper'

feature "sign_in as user: " do
  given!(:user) { FactoryGirl.attributes_for(:user) }
  given!(:new_user) { FactoryGirl.attributes_for(:user_two) }
  given!(:invalid_user) { FactoryGirl.attributes_for(:invalid_user) }
  given!(:old_user) { FactoryGirl.create(:user) }

  # sign in via html
  scenario 'new session (sign_in) with valid attributes' do
    visit home_path

    click_link "sign in"

    expect(page).to have_content('Log in')
    expect(current_path).to eq '/sign_in'
    fill_in 'Name', with: user[:name]
    fill_in 'Password', with: user[:password]

    click_button "Log in"

    expect(page).to have_selector('.alert-info')
    expect(page).to have_content(user[:name])
    expect(current_path).to eq '/'
  end

  # sign in via html
  scenario 'new session (sign_in) with invalid attributes' do
    visit home_path

    click_link "sign in"

    expect(page).to have_content('Log in')
    expect(current_path).to eq '/sign_in'
    fill_in 'Name', with: invalid_user[:name]
    fill_in 'Password', with: invalid_user[:password]

    click_button "Log in"

    expect(page).to have_selector('.alert-warning')
    expect(page).to have_content('Log in')
    expect(current_path).to eq '/sign_in'
  end

  # sign in via html
  scenario 'new session (sign_in) with wrong password' do
    visit home_path

    click_link "sign in"

    expect(page).to have_content('Log in')
    expect(current_path).to eq '/sign_in'
    fill_in 'Name', with: user[:name]
    fill_in 'Password', with: 'this_is_wrong'

    click_button "Log in"

    expect(page).to have_selector('.alert-warning')
    expect(page).to have_content('Log in')
    expect(current_path).to eq '/sign_in'
  end
end

feature "sign in as user while already a guest: ", js: true do
  given!(:user) { FactoryGirl.create(:user) }
  given!(:new_user) { FactoryGirl.attributes_for(:user_two) }
  given!(:invalid_user) { FactoryGirl.attributes_for(:invalid_user) }
  given!(:quotum) { FactoryGirl.create(:quotum) }
  given(:new_quotum) { FactoryGirl.attributes_for(:quotum) }

  # simulate creation of guest account
  before(:each) do
    quotum
    visit quota_path
    click_link "New Quotum (remote)"

    wait_for_ajax
    fill_in 'Name', with: new_quotum[:name]

    click_button "Create Quotum"
    wait_for_ajax
  end

  scenario 'before should already by signed in as guest' do
    visit home_path
    expect(page).to have_content(Constants::GUEST_DISPLAY_NAME)
    expect(page).to have_selector('.guest-name', count: 1)
  end

  # sign in via html
  scenario 'new session (sign_in) with valid attributes' do
    visit home_path

    expect {
      find('.user-guest-menu', match: :first).click
      click_link "sign in"

      expect(page).to have_content('Log in')
      expect(current_path).to eq '/sign_in'
      fill_in 'Name', with: user.name
      fill_in 'Password', with: user.password

      click_button "Log in"

      expect(page).to have_selector('.alert-info')
      expect(page).to have_content(user.name, count: 1)
      expect(current_path).to eq '/'
    }.to change(User.guests, :count).by(-1)
  end

  # sign in via html
  scenario 'new session (sign_in) with invalid attributes' do
    visit home_path

    find('.user-guest-menu', match: :first).click
    click_link "sign in"

    expect(page).to have_content('Log in')
    expect(current_path).to eq '/sign_in'
    fill_in 'Name', with: invalid_user[:name]
    fill_in 'Password', with: invalid_user[:password]

    click_button "Log in"

    expect(page).to have_selector('.alert-warning')
    expect(page).to have_content('Log in')
    expect(current_path).to eq '/sign_in'
    expect(page).to have_content(Constants::GUEST_DISPLAY_NAME)
    expect(page).to have_selector('.guest-name', count: 1)
  end

  # sign in via html
  scenario 'new session (sign_in) with wrong password' do
    visit home_path

    find('.user-guest-menu', match: :first).click
    click_link "sign in"

    expect(page).to have_content('Log in')
    expect(current_path).to eq '/sign_in'
    fill_in 'Name', with: user.name
    fill_in 'Password', with: 'this_is_wrong'

    click_button "Log in"

    expect(page).to have_selector('.alert-warning')
    expect(page).to have_content('Log in')
    expect(current_path).to eq '/sign_in'
    expect(page).to have_content(Constants::GUEST_DISPLAY_NAME)
    expect(page).to have_selector('.guest-name', count: 1)
  end
end

