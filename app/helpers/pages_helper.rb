module PagesHelper

  # Display partial conditional on current_user
  def display_user(user_account = nil)
    if user_account
      if user_account.is_guest?
        render('shared/user_partials/guest_user', user: user_account)
      else
        render('shared/user_partials/current_user', user: user_account)
      end
    else
      render('shared/user_partials/blank_user')
    end
  end
end
