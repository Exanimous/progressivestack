module SmartFilter
  extend ActiveSupport::Concern

  # return false if web urls or email addresses are found in string
  # Examples:
  # 1: www.test.com
  # 2: http://test.net
  # 3: w w w . t e s t . c o m
  # 4: test@test. c o m
  # 5: test dot com
  def filter_web_and_email
    if (self.name =~ /(https|http|ftp|ftps|www.|w w w|@|dot|:\/\/|\.\S{1,3}|\.)/).present?
      errors.add(:name, "contains characters that are unavailable")
    end
  end
end