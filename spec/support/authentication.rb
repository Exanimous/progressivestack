module Authentication

  # compatibility method
  # forces creation of session for manual controller tests
  # should not be used elsewhere
  def login_guest_user_compatibility
    @request.env["devise.mapping"] = Devise.mappings[:guest]
    guest = FactoryGirl.create(:guest)
    sign_in guest
    session[:guest_user_id] = guest.id
    guest
  end
end