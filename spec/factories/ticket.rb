FactoryBot.define do
  factory :ticket do
    user
    event
    comment 'TEST_TICKET_COMMENT'

    trait :ticket_2 do
      comment 'TEST_TICKET_COMMENT_2'
    end
  end
end
