FactoryGirl.define do
  factory :quotum do |f|
    f.name "Testing 123"
  end

  factory :invalid_quotum, class: Quotum do |f|
    f.name ""
  end
end
