FactoryBot.define do
  factory :user do
    provider 'twitter'
    uid '12345'
    nickname 'netwillnet'
    image_url 'http://example.com/netwillnet.jpg'
  end
end
