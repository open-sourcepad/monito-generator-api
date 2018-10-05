FactoryBot.define do
  factory :auth_token do
    user_id { 1 }
    expiry { "2018-10-05" }
    auth_hash { "MyString" }
  end
end
