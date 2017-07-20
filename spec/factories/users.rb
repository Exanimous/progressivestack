FactoryGirl.define do
  factory :user do |f|
    f.name 'current-user'
    f.email 'current-user@progressivestack.com'
    f.password 'hunter2'
  end

  factory :user_tenant do |f|
    f.permission_level 3
  end

  factory :user_two, class: User do |f|
    f.name 'current-user-2'
    f.email 'current-user-2@progressivestack.com'
    f.password 'hunter2'
  end

  factory :invalid_user, class: User do |f|
    f.name nil
    f.email nil
  end

  factory :guest, class: User do |f|
    f.name 'current-guest'
    f.email nil
    f.password 'hunter2'
    f.guest true

    factory :guest_skip_validate do
      to_create {|instance| instance.save(validate: false) }
    end
  end

  factory :invalid_guest, class: User do |f|
    f.name ''
    f.guest true
  end
end
