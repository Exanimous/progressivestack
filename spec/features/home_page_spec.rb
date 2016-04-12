require 'rails_helper'
RSpec.feature "home page" do

  # basic template test - check home page displays
  scenario " display home page" do

    visit home_path

    expect(page).to have_content("Hello world!")
  end
end