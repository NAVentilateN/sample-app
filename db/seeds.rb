# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

User.create!(name: "test",
            first_name: "test", 
            last_name:"test", 
            email:"test@test.com", 
            password:"foobar",
            password_confirmation: "foobar",
            admin: true,
            activated: true,
            activated_at: Time.zone.now)

puts "Created test user"

50.times do |n|
  name  = Faker::Name.name      
  first_name  = Faker::Name.first_name       
  last_name  = Faker::Name.last_name        
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               first_name: first_name,
               last_name: last_name,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

puts "Created 50 random users"

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end

puts "Created 50 random microposts"