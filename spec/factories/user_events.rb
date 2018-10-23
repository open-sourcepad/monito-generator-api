FactoryBot.define do
  factory :user_event do
    user_id { 1 }
    circle_id { 1 }
    exchange_date { "2018-10-23" }
    desc { "MyString" }
    deadline { false }
  end
end
