# spec/features/authentication/sign_up_spec.rb
require 'rails_helper'

feature "sign_up as user: " do
  given!(:user) { FactoryGirl.attributes_for(:user) }
  given!(:new_user) { FactoryGirl.attributes_for(:user_two) }
  given!(:invalid) { FactoryGirl.attributes_for(:invalid_user) }

  # sign up via html
  scenario 'new registration (sign_up) with valid attributes' do
    visit home_path

    click_link "sign up"

    expect(page).to have_content('Sign up')
    expect(current_path).to eq '/sign_up'
    fill_in 'Name', with: user[:name]
    fill_in 'Email', with: user[:email]
    fill_in 'user_password', with: user[:password]
    fill_in 'user_password_confirmation', with: user[:password]

    click_button "Sign up"

    expect(page).to have_selector('.alert-info')
    expect(page).to have_content(user[:name], count: 1)
    expect(current_path).to eq '/'
  end

  # sign up via html
  scenario 'new registration (sign_up) with invalid attributes' do
    visit home_path

    click_link "sign up"

    expect(page).to have_content('Sign up')
    expect(current_path).to eq '/sign_up'
    fill_in 'Name', with: invalid[:name]
    fill_in 'Email', with: invalid[:email]
    fill_in 'user_password', with: invalid[:password]
    fill_in 'user_password_confirmation', with: invalid[:password]

    click_button "Sign up"

    expect(page).to have_selector('.alert-danger')
    expect(page).to have_content('sign up')
    expect(current_path).to eq '/sign_up'
  end

  # sign in via html
  scenario 'new registration (sign_up) with wrong password confirmation' do
    visit home_path

    click_link "sign up"

    expect(page).to have_content('Sign up')
    expect(current_path).to eq '/sign_up'
    fill_in 'Name', with: user[:name]
    fill_in 'Email', with: user[:email]
    fill_in 'user_password', with: 'this is wrong'
    fill_in 'user_password_confirmation', with: 'this is wrong 2'

    click_button "Sign up"

    expect(page).to have_selector('.alert-danger')
    expect(page).to have_content('sign up')
    expect(current_path).to eq '/sign_up'
  end
end

feature "sign_up as user while already a guest ", js: true do
  given!(:user) { FactoryGirl.attributes_for(:user) }
  given!(:new_user) { FactoryGirl.attributes_for(:user_two) }
  given!(:invalid) { FactoryGirl.attributes_for(:invalid_user) }
  given!(:quotum) { FactoryGirl.create(:quotum) }

  # simulate creation of guest account
  before(:each) do
    quotum
    visit quota_path
    accept_confirm do
      click_link 'Delete'
      wait_for_ajax
    end
  end

  scenario 'before should already by signed in as guest' do
    visit home_path
    expect(page).to have_content(Constants::GUEST_DISPLAY_NAME, count: 1)
  end

  # sign up via html
  scenario 'new registration (sign_up) with valid attributes' do
    visit home_path

    expect {
      click_link "sign up"

      expect(page).to have_content('Sign up')
      expect(current_path).to eq '/sign_up'
      fill_in 'Name', with: user[:name]
      fill_in 'Email', with: user[:email]
      fill_in 'user_password', with: user[:password]
      fill_in 'user_password_confirmation', with: user[:password]

      click_button "Sign up"

      expect(page).to have_selector('.alert-info')
      expect(page).to have_content(user[:name], count: 1)
      expect(current_path).to eq '/'
    }.to change(User.guests, :count).by(-1)
  end

  # sign up via html
  scenario 'new registration (sign_up) with invalid attributes' do
    visit home_path

    click_link "sign up"

    expect(page).to have_content('Sign up')
    expect(current_path).to eq '/sign_up'
    fill_in 'Name', with: invalid[:name]
    fill_in 'Email', with: invalid[:email]
    fill_in 'user_password', with: invalid[:password]
    fill_in 'user_password_confirmation', with: invalid[:password]

    click_button "Sign up"

    expect(page).to have_selector('.alert-danger')
    expect(page).to have_content('sign up')
    expect(current_path).to eq '/sign_up'
    expect(page).to have_content(Constants::GUEST_DISPLAY_NAME, count: 1)
  end
end
