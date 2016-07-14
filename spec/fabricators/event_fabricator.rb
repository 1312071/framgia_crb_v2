Fabricator :event do
  title {Faker::Lorem.word}
  user_id
  description {Faker::Lorem.sentence}
  start_date {DateTime.new(2016,2,3,8,0,0,"+7")}
  finish_date {DateTime.new(2016,2,3,8,0,0,"+7")}
  start_repeat {DateTime.new(2016,2,3,8,0,0,"+7")}
  end_repeat {DateTime.new(2016,2,3,8,0,0,"+7")}
  calendar_id
  place_id
  repeat_type
  repeat_every
  chatwork_room_id Settings.chatwork_room_id
  message_content {Faker::Lorem.sentence}
  task_content {Faker::Lorem.sentence}
end
