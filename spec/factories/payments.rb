FactoryBot.define do
  factory :payment do
    rental_application { nil }
    amount { "9.99" }
    currency { "MyString" }
    status { 1 }
    transaction_id { "MyString" }
    momo_response { "MyText" }
  end
end
