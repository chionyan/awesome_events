FactoryBot.define do
  factory :ticket do
    user
    event
    comment 'TEST_TICKET_COMMENT'
  end
end
