# spec/features/show_quotum_spec.rb
require 'rails_helper'

RSpec.feature "Feature: show quotum: " do
  before :each do
    @user = FactoryGirl.create(:user)
    login_as @user
    @quotum = FactoryGirl.create(:quotum, name: "show rspec quotum", tenant_id: @user.tenant_ids.first)
  end

  # visit via remote link (js)
  scenario 'show quotum (remote/js)', js: true do
    Capybara.javascript_driver = :selenium

    visit quota_path

    click_link "#{@quotum.name}"

    wait_for_ajax
    expect(page).to have_content("viewing #{@quotum.name}")
    expect(page).to have_title "#{@quotum.name} | Progressivestack"
  end

  # simulate visit and update via url (html)
  scenario 'show quotum via url (html)', js: true do
    Capybara.javascript_driver = :selenium
    visit quotum_path(@quotum)

    wait_for_ajax
    expect(page).to have_content("viewing #{@quotum.name}")
    expect(page).to have_title "#{@quotum.name} | Progressivestack"
  end
end
