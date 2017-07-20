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
  given!(:spam_quotum) { FactoryGirl.build(:spam_quotum) }
  before :each do
    @user = FactoryGirl.create(:user)
    login_as @user
    @quotum = FactoryGirl.create(:quotum, name: "update rspec quotum", tenant_id: @user.tenant_ids.first)
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

  # due to parameterization called on name to generate slug - sometimes slug will be non-unique
  # tests when we create a quotum with valid name and invalid slug due to parameterization
  scenario 'update quotum with name that creates invalid slug (html)', js: true do
    Capybara.javascript_driver = :selenium

    @quotum_dup = FactoryGirl.create(:quotum, name: "update rspec quotum placeholder", tenant_id: @user.tenant_ids.first)
    visit edit_quotum_path(@quotum_dup)

    expect(page).to have_content("Editing #{@quotum_dup.name}")
    fill_in 'Name', with: "update rspec & quotum"
    click_button "Update Quotum"

    expect(page).to have_selector('.alert-danger')
    expect(page).to have_content("Name is unavailable")
    expect(page).to have_title "Editing #{@quotum_dup.name} | Progressivestack"
    expect(page).to have_content("Editing #{@quotum_dup.name}")
  end

  # visit and update via remote link (js)
  # perform update action
  scenario 'update quotum with spam input (remote/js)', js: true do
    Capybara.javascript_driver = :selenium

    expect {
      visit quota_path

      click_link "Edit"

      wait_for_ajax

      expect(page).to have_content('Name')
      expect(page).to have_content("Editing #{@quotum.name}")

      fill_in 'Name', with: spam_quotum.name

      click_button "Update Quotum"

      expect(page).to have_selector('.alert-success')
      expect(page).not_to have_content(new_quotum.name)
      expect(page).to have_title "Quota index | Progressivestack"
      expect(@quotum.name).to_not eq(new_quotum.name)
    }.to change(Quotum.visible, :count)
  end

  # simulate visit and update via url (html)
  # perform update action
  scenario 'update quotum with spam input via url (html)', js: true do
    Capybara.javascript_driver = :selenium

    expect {
      visit edit_quotum_path(@quotum)

      expect(page).to have_content("Editing #{@quotum.name}")
      fill_in 'Name', with: spam_quotum.name

      click_button "Update Quotum"

      expect(page).to have_selector('.alert-success')
      expect(page).not_to have_content(new_quotum.name)
      expect(page).to have_title "Quota index | Progressivestack"
      expect(@quotum.name).to_not eq(new_quotum.name)
    }.to change(Quotum.visible, :count)
  end

end
