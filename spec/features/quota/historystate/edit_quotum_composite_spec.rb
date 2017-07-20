# spec/features/edit_quotum_composite_spec.rb
require 'rails_helper'

# feature spec to test:
# new quotum, create, update index display

RSpec.feature "Feature: edit quotum & historystate: " do
  given!(:quotum) { FactoryGirl.build(:quotum, name: "rspec quotum") }
  given!(:invalid_quotum) { FactoryGirl.build(:invalid_quotum) }

  before :each do
    @user = FactoryGirl.create(:user)
    login_as @user
    @quotum = FactoryGirl.create(:quotum, name: "RSpec Quotum", tenant_id: @user.tenant_ids.first)
  end

  # historystate scenario test
  # 1: edit quotum (html)
  # 2: close modal
  # 3: expect to view quotum in index view
  scenario 'edit quotum then close modal (via html)', js: true do
    Capybara.current_driver = :selenium
    edit_then_close_html
  end

  # historystate scenario test
  # 1: edit quotum (js/remote)
  # 2: close modal
  # 3: expect to view quotum in index view
  scenario 'edit quotum then close modal (via js/remote)', js: true do
    Capybara.current_driver = :selenium
    edit_then_close_js
  end

  # historystate scenario test
  # 1: edit quotum (html)
  # 2: browser back
  # 3: expect to view quotum in index view
  scenario 'edit quotum then back (via html)', js: true do
    Capybara.current_driver = :selenium
    edit_then_back_html
  end

  # historystate scenario test
  # 1: edit quotum (js/remote)
  # 2: browser back
  # 3: expect to view quotum in index view
  scenario 'edit quotum then back (via js/remote)', js: true do
    Capybara.current_driver = :selenium
    edit_then_back_js
  end

  scenario 'edit quotum direct via url', js: true do
    Capybara.current_driver = :selenium
    visit edit_quotum_path(@quotum, format: :html)

    wait_for_ajax

    has_form

    click_button "Close"

    has_partial

    has_layout
  end

  # composite test
  # 1: edit quotum (html)
  # 2: back
  # 3: forward
  # 4: close
  # 5: edit quotum (js)
  # 6: back
  scenario 'edit(html)/back/forward/close/edit(js)/back', js: true do
    Capybara.current_driver = :selenium

    visit edit_quotum_path(@quotum, format: :html)
    wait_for_ajax
    has_form

    go_back

    be_blank

    go_forward

    wait_for_ajax

    has_form

    click_button "Close"

    has_partial
    has_layout

    click_link "Edit"
    has_form

    go_back
    wait_for_ajax

    has_partial
    has_layout
  end

  private

  def edit_then_close_html
    visit quota_path

    visit edit_quotum_path(@quotum, format: :html)

    wait_for_ajax

    has_form

    click_button "Close"

    has_partial

    has_layout
  end

  def edit_then_close_js
    visit quota_path

    click_link "Edit"

    wait_for_ajax

    has_form

    click_button "Close"

    has_partial

    has_layout
  end

  def edit_then_back_html
    visit quota_path

    visit edit_quotum_path(@quotum, format: :html)

    wait_for_ajax

    has_form

    page.driver.go_back

    has_partial

    has_layout
  end

  def edit_then_back_js
    visit quota_path

    click_link "Edit"

    wait_for_ajax

    has_form

    page.driver.go_back

    has_partial

    has_layout
  end

  def has_form
    expect(page).to have_content('Name')
    expect(page).to have_title "Editing #{@quotum.name} | Progressivestack"
  end

  def has_partial
    expect(page).to have_content(@quotum.name)
    expect(page).to have_title "Quota index | Progressivestack"
  end

  def be_blank
    expect(page).not_to have_title "New quotum | Progressivestack"
    expect(page).not_to have_selector('.navbar-fixed-top')
    expect(page).not_to have_selector('.footer-bottom')
  end

  # ensure that navbar & footer is displayed
  # if not displayed - then partial render logic error is present
  def has_layout
    expect(page).to have_selector('.navbar-fixed-top')
    expect(page).to have_selector('.footer-bottom')
  end
end