class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  # declare additional permitted parameters here (along with source restful action)
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email])
    devise_parameter_sanitizer.permit(:edit_account, keys: [:email])
  end

  # override to provide exception for guest_user
  # this will allow creation of new accounts while signed in as a guest
  def require_no_authentication
    return if current_guest else super
  end

  def create
    super
    current_or_guest_user
  end

  def update
    current_guest.present? ? (head 403) : super
  end

  # for guest_users, session is destroyed instead
  def destroy
    current_guest.present? ? (head 403) : super
  end
end