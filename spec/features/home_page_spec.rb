# spec/features/home_page_spec.rb
require 'rails_helper'

RSpec.feature "home page" do

  # basic template test - check home page displays
  scenario 'Feature: display home page correctly' do

    visit home_path

    expect(page).to have_content("Hello world!")
  end
end