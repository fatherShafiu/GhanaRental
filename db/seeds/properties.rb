# Create sample properties if they don't exist
if Property.count.zero?
  puts "Creating sample properties..."

  # Get or create a landlord user
  landlord = User.find_or_create_by!(
    email: 'landlord@example.com',
    role: :landlord
  ) do |user|
    user.password = 'password123'
    user.password_confirmation = 'password123'
  end

  # Create landlord profile if it doesn't exist
  unless landlord.profile
    landlord.create_profile!(
      first_name: 'John',
      last_name: 'PropertyOwner',
      phone_number: '+1234567890',
      date_of_birth: '1980-01-01',
      bio: 'Experienced property landlord with multiple rental units',
      verified: true
    )
  end

  properties_data = [
    {
      title: "Modern Downtown Apartment",
      description: "Beautiful modern apartment in the heart of downtown. Features stainless steel appliances, hardwood floors, and amazing city views.",
      property_type: "apartment",
      price: 1500.00,
      bedrooms: 2,
      bathrooms: 1,
      square_feet: 850,
      address: "123 Main St",
      city: "Accra",
      state: "Greater Accra",
      zip_code: "00233",
      available_from: Date.today + 7.days
    },
    {
      title: "Spacious Family House",
      description: "Perfect for families, this spacious house features a large backyard, updated kitchen, and plenty of storage space.",
      property_type: "house",
      price: 2200.00,
      bedrooms: 4,
      bathrooms: 2,
      square_feet: 1800,
      address: "456 Oak Avenue",
      city: "Kumasi",
      state: "Ashanti",
      zip_code: "00233",
      available_from: Date.today + 14.days
    },
    {
      title: "Luxury Waterfront Condo",
      description: "Stunning waterfront condo with panoramic ocean views. Features high-end finishes, balcony, and resort-style amenities.",
      property_type: "condo",
      price: 3200.00,
      bedrooms: 3,
      bathrooms: 2,
      square_feet: 1200,
      address: "789 Beach Road",
      city: "Tema",
      state: "Greater Accra",
      zip_code: "00233",
      available_from: Date.today + 30.days
    }
  ]

  properties_data.each do |property_data|
    property = landlord.properties.create!(property_data)
    property.published! # Set status to published
    puts "Created property: #{property.title}"
  end
end
