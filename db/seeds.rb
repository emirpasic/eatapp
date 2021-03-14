# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

password = Rails.application.credentials.master_password

admin1_user = User.create(username: "admin1", password: password)
restaurant1_user = User.create(username: "restaurant1", password: password)
restaurant2_user = User.create(username: "restaurant2", password: password)
guest1_user = User.create(username: "guest1", password: password)
guest2_user = User.create(username: "guest2", password: password)
