class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # note: behaviour changed in rails 5
  protect_from_forgery with: :exception, prepend: true
  include UserControl
  include Tenancy

  before_action :enable_access_control

  #around_action :scope_quota_tenancy
  #around_action :scope_user_tenancy # currently disabled (may be turned on for certain controller actions in future)
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  def render_404
    render file: 'public/404', status: :not_found
  end

  def enable_access_control
    @access_control = AccessControl.new(current_or_guest_user)
  end
end
