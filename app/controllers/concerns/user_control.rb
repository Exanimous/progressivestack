module UserControl
  extend ActiveSupport::Concern

  # /* Handle current_user and guest_user control logic here */
  # NOTE: directly override devise helper methods in config/initializers/devise_helpers.rb


  included do
    helper_method :current_user
    helper_method :current_or_guest_user
    helper_method :current_guest
    helper_method :guest_signed_in?
    helper_method :remove_guest
  end

  private

  # return current user unless is_guest?
  def current_user
    logger.debug 'ApplicationController:current_user'
    @current_user ||= super
    @current_user && @current_user.is_guest? ? nil : @current_user
  end

  # if current user is signed in, return current user, else return guest_user
  # if current_user, ensure guest session is destroyed
  # note: as with current_user -> this method will only create a new guest if create_guest = false
  def current_or_guest_user(create_guest = false)
    @current_or_guest_user ||=
    (
      logger.debug 'ApplicationController:current_or_guest_user'
      if current_user
        if session[:guest_user_id] && session[:guest_user_id] != current_user.id
          remove_guest
          logger.debug "ApplicationController:current_or_guest_user >>> current_user and guest_user session found -- guest_user remove and return current_user"
        end
        current_user
      else
        logger.debug "ApplicationController:current_or_guest_user >>> current_user not found -- switching to guest_user with create = #{create_guest}"
        guest_user(create_guest)
      end
    )
  end

  # find current_guest
  def current_guest(allow_create = false)
    guest_user(allow_create) if session[:guest_user_id]
  end

  # is signed in as guest?
  def guest_signed_in?
    !!current_guest
  end

  # remove guest (with conditional db deletion)
  def remove_guest(log_in = true, with_destroy = true)
    logger.debug "ApplicationController:remove_guest >>> removing guest with log_in = #{log_in} and with_destroy = #{with_destroy}"
    logging_in if log_in
    guest_user(false).reload.try(:destroy) if with_destroy     # reload guest_user to prevent caching problems before destruction
    with_destroy ? @cached_guest_user.delete : (@cached_guest_user = nil)     # chose to delete guest by default, or persist in DB
    session[:guest_user_id] = nil
  end

  # find guest user linked to current session
  # if blank -> create one
  # if create == true, create new guest_user if not found
  def guest_user(allow_create = false)
    if allow_create
      @cached_guest_user ||= User.find(session[:guest_user_id] || create_guest_user.id)
    else
      @cached_guest_user ||= User.find(session[:guest_user_id])
    end

  rescue ActiveRecord::RecordNotFound
    # only allow retry if allow_create == true
    session[:guest_user_id] = nil
    guest_user if allow_create
  end

  # Called once when a user logs in (from guest_user to current_user)
  # use to transfer data from guest_user to current_user
  def logging_in
    logger.debug "ApplicationController:logging_in >>> "
    current_user.transfer_data(guest_user)
  end

  # Create guest user record (with appropriate defaults)
  # Skip model validations
  def create_guest_user
    logger.debug "ApplicationController:create_guest_user >>> creating new guest_user record"
    guest = User.new_guest_user
    session[:guest_user_id] = guest.id
    guest
  end
end