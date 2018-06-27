FactoryBot.define do
  factory :user do
    provider 'twitter'
    sequence(:uid, 12_345, &:to_s)
    nickname 'netwillnet'
    image_url 'http://example.com/netwillnet.jpg'
  end
end
