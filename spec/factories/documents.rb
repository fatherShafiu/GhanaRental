FactoryBot.define do
  factory :document do
    rental_application { nil }
    user { nil }
    document_type { "MyString" }
    file_data { "MyText" }
  end
end
