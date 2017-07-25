# spec/features/quota_index_spec.rb
require 'rails_helper'

RSpec.feature "quota index" do

  # basic template test - check home page displays
  scenario 'Feature: display quota index correctly' do

    visit quota_path

    expect(page).to have_content('Quota')
    expect(page).to have_http_status('200')
  end
end

RSpec.feature "Feature: quota index content while not signed in" do

  scenario 'index displays quota_view_only', js: true do
    Capybara.javascript_driver = :selenium
    user_one = FactoryGirl.create(:user)
    user_two = FactoryGirl.create(:user_two)

    quotum_one = FactoryGirl.create(:user_quotum, tenant_id: user_one.tenant_ids.first)
    quotum_two = FactoryGirl.create(:user_quotum_two, tenant_id: user_two.tenant_ids.first)
    quotum_nil = FactoryGirl.create(:user_quotum_three, tenant_id: nil)

    visit quota_path

    expect(page).to have_content("#{quotum_one.name} (view only)")
    expect(page).to have_content("#{quotum_two.name} (view only)")
    expect(page).to have_content("#{quotum_nil.name} (view only)")
  end
end

RSpec.feature "Feature: quota index content while signed in as user" do
  before :each do
    @user = FactoryGirl.create(:user)
    login_as @user
  end

  scenario 'index displays quota_controllable and quota_view_only', js: true do
    Capybara.javascript_driver = :selenium
    user_two = FactoryGirl.create(:user_two)

    quotum = FactoryGirl.create(:user_quotum, tenant_id: @user.tenant_ids.first)
    quotum_two = FactoryGirl.create(:user_quotum_two, tenant_id: user_two.tenant_ids.first)
    quotum_nil = FactoryGirl.create(:user_quotum_three, tenant_id: nil)

    visit quota_path

    expect(page).to have_content(quotum.name)
    expect(page).to have_content("#{quotum_two.name} (view only)")
    expect(page).to have_content("#{quotum_nil.name} (view only)")
  end
end

RSpec.feature "Feature: quota index content while signed in as guest" do
  # simulate guest creation
  before :each do
    @quotum_guest = FactoryGirl.build(:user_quotum)
    visit quota_path

    click_link "New Quotum (remote)"

    wait_for_ajax
    fill_in 'Name', with: @quotum_guest[:name]

    click_button "Create Quotum"
    wait_for_ajax
  end

  scenario 'index displays quota_controllable and quota_view_only', js: true do
    Capybara.javascript_driver = :selenium
    user_two = FactoryGirl.create(:user_two)

    quotum_two = FactoryGirl.create(:user_quotum_two, tenant_id: user_two.tenant_ids.first)
    quotum_nil = FactoryGirl.create(:user_quotum_three, tenant_id: nil)

    visit quota_path

    expect(page).to have_content(@quotum_guest.name)
    expect(page).to have_content("#{quotum_two.name} (view only)")
    expect(page).to have_content("#{quotum_nil.name} (view only)")
  end
end