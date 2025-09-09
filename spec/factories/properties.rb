FactoryBot.define do
  factory :property do
    landlord { nil }
    title { "MyString" }
    description { "MyText" }
    property_type { "MyString" }
    price { "9.99" }
    bedrooms { 1 }
    bathrooms { 1 }
    square_feet { 1 }
    address { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zip_code { "MyString" }
    latitude { "9.99" }
    longitude { "9.99" }
    status { 1 }
    featured { false }
    available_from { "2025-09-09" }
  end
end
