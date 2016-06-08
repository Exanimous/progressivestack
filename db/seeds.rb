# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Quotum.destroy_all

20.times do |i|
  Quotum.create!(name: "Seed quotum number #{i+1}")
end

p "db:seed -- Created #{Quotum.count} quotum."
