module UserUtilities
  extend ActiveSupport::Concern

  # /* specific to user authentication functionality */

  class_methods do
    # create new guest user with random name
    # set guest value to true
    def new_guest_user
      guest = User.new(name: "guest_#{SecureRandom.urlsafe_base64(7)}", guest: true)
      guest.save!(validate: false)
      guest
    end
  end

  included do
    # TODO: copy data from guest account to new user
    def transfer_data(guest)
      logger.debug "UserUtilities >>> transfer_data"
      # iterate through guest associated objects and change id (ownership) to self
    end
  end

end