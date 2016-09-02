FactoryGirl.define do
  factory :quotum do |f|
    f.name "testing 123"
  end

  factory :invalid_quotum, class: Quotum do |f|
    f.name ""
  end
end
