# spec/features/new_quotum_composite_spec.rb
require 'rails_helper'

# feature spec to test:
# new quotum, create, update index display

RSpec.feature "Feature: new quotum & historystate: " do
  given!(:quotum) { FactoryGirl.build(:quotum, name: "RSpec Quotum") }
  given!(:invalid_quotum) { FactoryGirl.build(:invalid_quotum) }

  #before :each do
  #  @quotum = FactoryGirl.create(:quotum, name: "RSpec Quotum")
  #end

  # historystate scenario test
  # 1: new quotum (html)
  # 2: close modal
  # 3: expect to view blank in index view
  scenario 'new quotum then close modal (via html)', js: true do
    Capybara.current_driver = :selenium
    new_then_close_html
  end

  # historystate scenario test
  # 1: new quotum (js/remote)
  # 2: close modal
  # 3: expect to view blank in index view
  scenario 'new quotum then close modal (via js/remote)', js: true do
    Capybara.current_driver = :selenium
    new_then_close_js
  end

  # historystate scenario test
  # 1: new quotum (html)
  # 2: browser back
  # 3: expect to view blank in index view
  scenario 'new quotum then back (via html)', js: true do
    Capybara.current_driver = :selenium
    new_then_back_html
  end

  # historystate scenario test
  # 1: new quotum (js/remote)
  # 2: browser back
  # 3: expect to view blank in index view
  scenario 'new quotum then back (via js/remote)', js: true do
    Capybara.current_driver = :selenium
    new_then_back_js
  end

  scenario 'new quotum direct via url', js: true do
    Capybara.current_driver = :selenium
    visit new_quotum_path(format: :html)

    wait_for_ajax

    has_form

    click_button "Close"

    has_partial

    has_layout
  end

  # composite test
  # 1: new quotum (html)
  # 2: back
  # 3: forward
  # 4: close
  # 5: new quotum (js)
  # 6: back
  scenario 'new(html)/back/forward/close/new(js)/back', js: true do
    Capybara.current_driver = :selenium

    visit new_quotum_path(format: :html)
    wait_for_ajax
    has_form

    go_back
    has_partial
    has_layout

    go_forward

    wait_for_ajax

    has_form

    click_button "Close"

    has_partial
    has_layout

    click_link "New Quotum (remote)"

    go_back
    has_partial
    has_layout
  end

  private

  def new_then_close_html
    visit quota_path

    visit new_quotum_path(format: :html)

    wait_for_ajax

    has_form

    click_button "Close"

    has_partial

    has_layout
  end

  def new_then_close_js
    visit quota_path

    click_link "New Quotum (remote)"

    wait_for_ajax

    has_form

    click_button "Close"

    has_partial

    has_layout
  end

  def new_then_back_html
    visit quota_path

    visit new_quotum_path(format: :html)

    wait_for_ajax

    has_form

    page.driver.go_back

    has_partial

    has_layout
  end

  def new_then_back_js
    visit quota_path

    click_link "New Quotum (remote)"

    wait_for_ajax

    has_form

    page.driver.go_back

    has_partial

    has_layout
  end

  def has_form
    expect(page).to have_content('Name')
    expect(page).to have_title "New quotum | Progressivestack"
  end

  def has_partial
    expect(page).to have_title "Quota index | Progressivestack"
  end

  # ensure that navbar & footer is displayed
  # if not displayed - then partial render logic error is present
  def has_layout
    expect(page).to have_selector('.navbar-fixed-top')
    expect(page).to have_selector('.footer-bottom')
  end
end