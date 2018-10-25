FactoryBot.define do
  factory :user do
    user_name { "sample_user" }
    email { "sample@email.com" }
    password_hash { "83u41u4urjiiifhieur" }
  end

end
