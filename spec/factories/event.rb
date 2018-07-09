FactoryBot.define do
  factory :event do
    owner
    name 'TEST_EVENT_NAME'
    place 'TEST_EVENT_PLACE'
    content 'TEST_EVENT_CONTENT'
    start_time '2018-07-07 19:00:00'
    end_time '2018-07-07 21:00:00'
  end
end
