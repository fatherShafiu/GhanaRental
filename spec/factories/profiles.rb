FactoryBot.define do
  factory :profile do
    user { nil }
    first_name { "MyString" }
    last_name { "MyString" }
    phone_number { "MyString" }
    date_of_birth { "MyText" }
    bio { "MyText" }
    avatar_data { "MyString" }
    preferences { "" }
    verified { false }
  end
end
