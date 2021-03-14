# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

password = Rails.application.credentials.master_password

admin1_user = AdminUser.create!(username: 'admin1', password: password)
restaurant1_user = RestaurantUser.create!(username: 'restaurant1', password: password)
restaurant2_user = RestaurantUser.create!(username: 'restaurant2', password: password)
guest1_user = GuestUser.create!(username: 'guest1', password: password,
                                first_name: 'guest', last_name: '1',
                                phone: '123123', email: 'guest1@test.com')
guest2_user = GuestUser.create!(username: 'guest2', password: password,
                                first_name: 'guest', last_name: '2',
                                phone: '321321', email: 'guest2@test.com')
