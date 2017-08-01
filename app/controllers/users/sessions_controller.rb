class Users::SessionsController < Devise::SessionsController

  # override to provide exception for guest_user
  # this will allow sign_in while already signed in as a guest
  def require_no_authentication
    return if current_guest
    super
  end

  def create
    # delete existing guest session if create is successful (only at final stage)
    # sign out of guest account but store as backup
    # able to restore guest session if sign in fails

    old, old_session = nil

    # back up the guest here
    # then remove active references
    if current_guest
      old = @cached_guest_user
      old_session = session[:guest_user_id]

      sign_out(guest_user)
      remove_guest(false, false)
    end

    # return warden fail/success depending on authentication success
    # restore guest user on warden authentication failure
    self.resource = warden.authenticate(auth_options)
    unless self.resource
      if old and old_session
        session[:guest_user_id] = old_session
        @cached_guest_user = old
        sign_in old
        throw(:warden)
      else
        throw(:warden)
      end
    end

    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)

    yield resource if block_given?

    # success: delete guest account
    old.delete if old

    session[:user_id] = resource.id
    respond_with resource, location: after_sign_in_path_for(resource)
    current_or_guest_user
  end

  # if guest user - delete model
  def destroy
    if current_guest
      destroy_id = current_guest.id
      signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      set_flash_message! :notice, :signed_out_guest if signed_out
      user_to_destroy = User.find(destroy_id)
      user_to_destroy.destroy
      yield if block_given?
      respond_to_on_destroy
    else
      super
    end
  end
end