# spec/features/quota_index_spec.rb
require 'rails_helper'

# feature spec to test:
# new quotum, create, update index display

RSpec.feature "Feature: destroy quotum (signed in as user): " do
  Capybara.javascript_driver = :webkit
  before :each do
    @user = FactoryGirl.create(:user)
    @quotum = FactoryGirl.create(:quotum, name: "update RSpec Quotum", tenant_id: @user.tenant_ids.first)
  end

  # perform delete action and accept alert dialog
  scenario 'delete quotum (accept alert)', js: true do
    Capybara.current_driver = :webkit

    login_as @user
    visit quota_path

    accept_confirm do

      expect {

        click_link 'Delete'#
        expect(page).to_not have_content(@quotum.name)

      }.to change(Quotum, :count).by(-1)
    end

  end

  # perform delete action but reject alert dialog
  scenario 'delete quotum (reject alert)', js: true do
    Capybara.current_driver = :webkit

    login_as @user
    visit quota_path

    dismiss_confirm do

      expect {
        click_link 'Delete'
        expect(page).to have_content(@quotum.name)

      }.to change(Quotum, :count).by(0)
    end

  end

end
