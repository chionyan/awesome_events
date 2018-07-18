FactoryBot.define do
  factory :event do
    owner
    name 'TEST_EVENT_NAME'
    place 'TEST_EVENT_PLACE'
    content 'TEST_EVENT_CONTENT'
    start_time '2018-07-07 19:00:00'
    end_time '2018-07-07 22:00:00'

    trait :past_event do
      name 'past_event_name'
      place 'past_event_place'
      content 'past_event_content'
      start_time '2018-07-07 18:00:00'
    end

    trait :future_event do
      name 'future_event_name'
      place 'future_event_place'
      content 'future_event_content'
      start_time '2018-07-07 20:00:00'
    end
  end
end
