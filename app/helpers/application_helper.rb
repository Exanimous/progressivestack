module ApplicationHelper

  # Select required bootstrap notifications (messages)
  def bootstrap_class_for(flash_type)
    case flash_type
      when "success"
        "alert-success"   # Green
      when "error"
        "alert-danger"    # Red
      when "alert"
        "alert-warning"   # Yellow
      when "notice"
        "alert-info"      # Blue
      else
        flash_type.to_s
    end
  end

  # Display page title
  def title(title_txt)
    content_for(:title) { title_txt }
  end

  # Display modal title
  def modal_header(title_txt)
    content_for(:modal_header) { title_txt }
  end

  # Handle html body class
  def body_class(class_name="body")
    content_for :body_class, class_name
  end

  # display inline form error messages
  def form_errors_for(object = nil)
    render('shared/form_partials/form_errors', target: object) if object and object.errors.present?
  end

  def update_user_status
    if guest_signed_in?
      render('shared/user_partials/update_guest_status')
    end
  end
end
