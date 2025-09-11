FactoryBot.define do
  factory :rental_application do
    property { nil }
    tenant { nil }
    status { 1 }
    message { "MyText" }
    submitted_at { "2025-09-11 11:42:23" }
  end
end
