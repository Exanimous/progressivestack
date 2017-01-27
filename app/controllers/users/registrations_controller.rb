class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  prepend_before_action :check_captcha, only: [:create]

  # declare additional permitted parameters here (along with source restful action)
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email])
    devise_parameter_sanitizer.permit(:edit_account, keys: [:email])
  end

  # override to provide exception for guest_user
  # this will allow creation of new accounts while signed in as a guest
  def require_no_authentication
    return if current_guest
    super
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

  private

  def check_captcha
    unless verify_recaptcha
      set_flash_message!(:error, :recaptcha_error)
      self.resource = resource_class.new sign_up_params
      self.resource.errors.add(:base, 'Recaptcha validation failed')
      respond_with_navigational(resource) { render :new }
    end
  end
end