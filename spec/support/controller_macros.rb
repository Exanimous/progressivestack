module ControllerMacros
  require 'devise'
  Warden.test_mode!

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @current_user = FactoryGirl.create(:user)
      sign_in @current_user
    end
  end

  def login_guest_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @current_guest = FactoryGirl.create(:guest_skip_validate)
      sign_in @current_guest, scope: :guest
      session[:guest_user_id] = @current_guest.id
    end
  end
end