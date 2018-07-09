FactoryBot.define do
  factory :event do
    owner { build(:user) }
    name 'TEST_EVENT_NAME'
    place 'TEST_EVENT_PLACE'
    content 'TEST_EVENT_CONTENT'
    start_time Time.zone.now
    end_time Time.zone.now + 1.hour
  end
end
