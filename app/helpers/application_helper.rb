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
end
