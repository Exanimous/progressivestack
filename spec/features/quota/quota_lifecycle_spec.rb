# spec/features/quota_lifecycle_spec.rb
require 'rails_helper'

RSpec.feature "Feature: delete user should remove quotum" do
  before :each do
    @user = FactoryGirl.create(:user)
    @quotum = FactoryGirl.create(:user_quotum, tenant_id: @user.tenant_ids.first)

    login_as @user

    visit quota_path

    click_link "New Quotum (remote)"

    wait_for_ajax
    fill_in 'Name', with: @quotum[:name]

    click_button "Create Quotum"
    wait_for_ajax

    visit quota_path
  end

  scenario 'index displays quotum', js: true do
    expect(page).to have_content("#{@quotum.name}")
  end

  scenario 'user deletion', js: true do
    Capybara.javascript_driver = :selenium

    find('.user-menu').click
    accept_confirm do
      click_on 'Delete account'
    end
    wait_for_ajax

    visit quota_path

    wait_for_ajax

    expect(page).not_to have_content("#{@quotum.name}")
  end
end

RSpec.feature "Feature: delete guest user should remove quotum" do
  before :each do
    @quotum = FactoryGirl.build(:user_quotum)

    visit quota_path

    click_link "New Quotum (remote)"

    wait_for_ajax
    fill_in 'Name', with: @quotum[:name]

    click_button "Create Quotum"
    wait_for_ajax

    visit quota_path
  end

  scenario 'index displays quotum', js: true do
    expect(page).to have_content("#{@quotum.name}")
  end

  scenario 'guest user deletion', js: true do
    Capybara.javascript_driver = :selenium

    find('.user-guest-menu').click
    accept_confirm do
      click_on 'delete guest account'
    end
    wait_for_ajax

    visit quota_path

    wait_for_ajax

    expect(page).not_to have_content("#{@quotum.name}")
  end
end

RSpec.feature "Feature: guest create quotum - sign up as user - delete user" do
  given!(:user) { FactoryGirl.attributes_for(:user) }

  before :each do
    @quotum = FactoryGirl.build(:user_quotum)

    visit quota_path

    click_link "New Quotum (remote)"

    wait_for_ajax
    fill_in 'Name', with: @quotum[:name]

    click_button "Create Quotum"
    wait_for_ajax

    visit quota_path
  end

  scenario 'index displays quotum', js: true do
    expect(page).to have_content("#{@quotum.name}")
  end

  scenario 'guest is present', js: true do
    expect(page).to have_content(Constants::GUEST_DISPLAY_NAME)
    expect(page).to have_selector('.guest-name', count: 1)
  end

  scenario "create user account and check for quotum's persistance", js: true do
    Capybara.javascript_driver = :selenium

    @user = FactoryGirl.build(:user)

    click_link "sign up"


    wait_for_ajax
    expect(page).to have_content('Sign up')
    expect(current_path).to eq '/sign_up'
    fill_in 'Name', with: user[:name]
    fill_in 'Email', with: user[:email]
    fill_in 'user_password', with: user[:password]
    fill_in 'user_password_confirmation', with: user[:password]

    click_button "Sign up"

    visit quota_path

    expect(page).to have_content(user[:name])
    expect(page).to have_content("#{@quotum.name}")
    expect(page).to have_content("Edit")

    find('.user-menu').click
    accept_confirm do
      click_on 'Delete account'
    end
    wait_for_ajax

    visit quota_path

    wait_for_ajax

    expect(page).not_to have_content("#{@quotum.name}")
  end
end
