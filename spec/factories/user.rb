FactoryBot.define do
  factory :user, aliases: [:owner] do
    provider 'twitter'
    sequence(:uid, 12345) { |n| "#{n}" }
    nickname 'netwillnet'
    image_url 'http://example.com/netwillnet.jpg'

    trait :user_2 do
      sequence(:uid, 23456) { |n| "#{n}" }
      nickname 'netwillnet_2'
      image_url 'http://example.com/netwillnet_2.jpg'
    end
  end
end
