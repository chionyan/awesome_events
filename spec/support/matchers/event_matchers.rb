RSpec::Matchers.define :have_event_attribute do |event|
  name = event.name
  place = event.place
  content = event.content
  holding_time = "#{event.start_time.strftime('%Y/%m/%d %H:%M')} - #{event.end_time.strftime('%Y/%m/%d %H:%M')}"
  description_message = "#{name}, #{place}, #{content}, #{holding_time}"

  match do |actual|
    actual.body.include?(name) && actual.body.include?(place) && actual.body.include?(content) && actual.body.include?(holding_time)
  end

  description { "text #{description_message}" }
  failure_message { "text #{description_message}" }
  failure_message_when_negated { "not text #{description_message}" }
end
