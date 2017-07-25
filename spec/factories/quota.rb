FactoryGirl.define do
  factory :quotum do |f|
    f.name "testing 123"
  end

  factory :user_quotum, class: Quotum do |f|
    f.name "testing 123 user quotum"
  end

  factory :user_quotum_two, class: Quotum do |f|
    f.name "testing 345 user quotum"
  end

  factory :user_quotum_three, class: Quotum do |f|
    f.name "testing 456 user quotum"
  end

  factory :invalid_quotum, class: Quotum do |f|
    f.name ""
  end

  factory :spam_quotum, class: Quotum do |f|
    f.name "viagra-test-123"
  end

  factory :forbidden_quotum, class: Quotum do |f|
    f.name "www . test . com"
  end
end
