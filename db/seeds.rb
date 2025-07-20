# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding database..."

puts "Deleting existing records..."
Trip.destroy_all
User.destroy_all

puts "Records deleted."

puts "Creating default user..."
james = User.create!(
  email: "james@james.com",
  password: "password")

puts "Created users: #{User.count}"

puts "Creating trips for user #{james.email}..."

james.trips.create!(
  name: "Trip to Paris",
  start_date: Date.new(2024, 5, 1),
  end_date: Date.new(2024, 5, 10),
  companions: 2,
  location: "Paris, France",
  activity: "Sightseeing",
  extra_information: "Visiting the Eiffel Tower and Louvre Museum."
)

james.trips.create!(
  name: "Beach Vacation",
  start_date: Date.new(2024, 6, 15),
  end_date: Date.new(2024, 6, 22),
  companions: 1,
  location: "Maldives",
  activity: "Relaxing on the beach",
  extra_information: "Staying at a beachfront resort."
)

james.trips.create!(
  name: "Hiking Drakensberg skies",
  start_date: Date.new(2024, 6, 15),
  end_date: Date.new(2024, 6, 22),
  companions: 2,
  location: "Lesotho",
  activity: "Hiking and skiing",
  extra_information: "Staying at a mountain lodge with guided hikes."
)

james.trips.create!(
  name: "Skydiving Adventure",
  start_date: Date.new(2024, 6, 15),
  end_date: Date.new(2024, 6, 22),
  companions: 1,
  location: "Dubai",
  activity: "Jumping of planes and skydiving",
  extra_information: "Staying at a luxury hotel with a view of the Palm Jumeirah."
)


puts "Created trips: #{james.trips.count}"

puts "Database seeding completed!"
