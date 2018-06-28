FactoryBot.define do
  factory :user do
    provider 'twitter'
    sequence(:uid, 12345) { |n| "#{n}" }
    nickname 'netwillnet'
    image_url 'http://example.com/netwillnet.jpg'
  end
end
