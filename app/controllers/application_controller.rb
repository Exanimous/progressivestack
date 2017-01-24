class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # note: behaviour changed in rails 5
  protect_from_forgery with: :exception, prepend: true
  include UserControl
end
