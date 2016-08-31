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