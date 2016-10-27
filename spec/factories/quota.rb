FactoryGirl.define do
  factory :quotum do |f|
    f.name "testing 123"
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
