# spec/features/authentication/quota_tenancy_spec.rb
require 'rails_helper'

feature "sign in as guest user: ", js: true do
  Capybara.current_driver = :webkit
  given!(:user) { FactoryGirl.create(:user) }
  given!(:new_user) { FactoryGirl.attributes_for(:user_two) }
  given(:new_quotum) { FactoryGirl.attributes_for(:quotum) }
  given(:updated_quotum) { FactoryGirl.attributes_for(:quotum, name: "updated rspec quotum") }

  # simulate creation of guest account - then simulate creation of a new quotum belonging to a different user
  before(:each) do
    new_quotum
    visit quota_path
    click_link "New Quotum (remote)"

    wait_for_ajax
    fill_in 'Name', with: new_quotum[:name]

    click_button "Create Quotum"
    wait_for_ajax

    # simulate new quotum belonging to a different user
    @new_user = FactoryGirl.create(:user_two)
    @new_user_quotum = FactoryGirl.create(:user_quotum_two, tenant_id: @new_user.tenant_ids.first)
  end

  scenario 'attempt to edit another users quotum - display 404 error page' do
    expect {

      visit quota_path

      visit edit_quotum_path(format: :html, slug: @new_user_quotum.slug)
      expect(page).to have_content("The page you were looking for doesn't exist.")

    }.to change(Quotum, :count).by(0)
  end

  scenario 'attempt to update another users quotum - fail and display 404 error page' do
    current_driver = Capybara.current_driver
    expect {
      Capybara.current_driver = :rack_test

      visit quota_path

      page.driver.put("/q/#{@new_user_quotum.slug}")

      expect(page).to have_content("The page you were looking for doesn't exist.")

    }.to change(Quotum, :count).by(0)
    Capybara.current_driver = current_driver
  end

  scenario 'attempt to delete another users quotum - fail and display 404 error page' do
    current_driver = Capybara.current_driver
    expect {
      Capybara.current_driver = :rack_test

      visit quota_path

      page.driver.delete("/q/#{@new_user_quotum.slug}")

      expect(page).to have_content("The page you were looking for doesn't exist.")

    }.to change(Quotum, :count).by(0)
    Capybara.current_driver = current_driver
  end
end

feature "sign in as user: ", js: true do
  Capybara.current_driver = :webkit
  given!(:user) { FactoryGirl.create(:user) }
  given!(:new_user) { FactoryGirl.attributes_for(:user_two) }
  given(:new_quotum) { FactoryGirl.attributes_for(:quotum) }
  given(:updated_quotum) { FactoryGirl.attributes_for(:quotum, name: "updated rspec quotum") }

  # simulate creation of user account - then simulate creation of a new quotum belonging to a different user
  before(:each) do
    visit home_path

    click_link "sign up"

    expect(page).to have_content('Sign up')
    expect(current_path).to eq '/sign_up'
    fill_in 'Name', with: user[:name]
    fill_in 'Email', with: user[:email]
    fill_in 'user_password', with: user[:password]
    fill_in 'user_password_confirmation', with: user[:password]

    click_button "Sign up"

    # simulate new quotum belonging to a different user
    @new_user = FactoryGirl.create(:user_two)
    @new_user_quotum = FactoryGirl.create(:user_quotum_two, tenant_id: @new_user.tenant_ids.first)
  end

  scenario 'attempt to edit another users quotum - display 404 error page' do
    expect {

      visit quota_path

      visit edit_quotum_path(format: :html, slug: @new_user_quotum.slug)
      expect(page).to have_content("The page you were looking for doesn't exist.")

    }.to change(Quotum, :count).by(0)
  end

  scenario 'attempt to update another users quotum - fail and display 404 error page' do
    current_driver = Capybara.current_driver
    expect {
      Capybara.current_driver = :rack_test

      visit quota_path

      page.driver.put("/q/#{@new_user_quotum.slug}")

      expect(page).to have_content("The page you were looking for doesn't exist.")

    }.to change(Quotum, :count).by(0)
    Capybara.current_driver = current_driver
  end

  scenario 'attempt to delete another users quotum - fail and display 404 error page' do
    current_driver = Capybara.current_driver
    expect {
      Capybara.current_driver = :rack_test

      visit quota_path

      page.driver.delete("/q/#{@new_user_quotum.slug}")

      expect(page).to have_content("The page you were looking for doesn't exist.")

    }.to change(Quotum, :count).by(0)
    Capybara.current_driver = current_driver
  end
end

feature "not signed in: ", js: true do
  Capybara.current_driver = :webkit
  given(:new_quotum) { FactoryGirl.attributes_for(:quotum) }
  given(:updated_quotum) { FactoryGirl.attributes_for(:quotum, name: "updated rspec quotum") }

  # simulate creation of an unclaimed (unowned) quotum
  before(:each) do
    visit home_path
    # simulate new quotum without tenant data
    @quotum = FactoryGirl.create(:quotum, name: "unowned-quotum")


    # simulate new quotum belonging to a different user
    @new_user = FactoryGirl.create(:user_two)
    @new_user_quotum = FactoryGirl.create(:user_quotum_two, tenant_id: @new_user.tenant_ids.first)
  end

  scenario 'visit index path - should see unowned quotum' do
    visit quota_path
    expect(page).to have_content("unowned-quotum")
  end

  scenario 'attempt to update another users quotum - fail and display 404 error page' do
    current_driver = Capybara.current_driver
    expect {
      Capybara.current_driver = :rack_test

      visit quota_path

      page.driver.put("/q/#{@new_user_quotum.slug}")

      expect(page).to have_content("The page you were looking for doesn't exist.")

    }.to change(Quotum, :count).by(0)
    Capybara.current_driver = current_driver
  end

end