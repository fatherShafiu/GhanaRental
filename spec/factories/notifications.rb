FactoryBot.define do
  factory :notification do
    user { nil }
    notifiable_type { "MyString" }
    notifiable_id { "" }
    read { false }
    message { "MyString" }
  end
end
