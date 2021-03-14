# Create users
password = Rails.application.credentials.master_password

# Create admin user
admin1_user = AdminUser.create!(username: 'admin1', password: password)

# Create restaurant users
restaurant1_user = RestaurantUser.create!(username: 'restaurant1', password: password)
restaurant2_user = RestaurantUser.create!(username: 'restaurant2', password: password)

# Create guest users
guest1_user = GuestUser.create!(username: 'guest1', password: password,
                                first_name: 'guest', last_name: '1',
                                phone: '123123', email: 'guest1@test.com')
guest2_user = GuestUser.create!(username: 'guest2', password: password,
                                first_name: 'guest', last_name: '2',
                                phone: '321321', email: 'guest2@test.com')

# Create restaurants
restaurant1 = Restaurant.create!(restaurant_user_id: restaurant1_user.id,
                                 name: 'restaurant1', cuisines: 'japanese',
                                 phone: '234234', email: ' restaurant1@test.com',
                                 location: 'Sarajevo, Bosnia and Herzegovina',
                                 opening_hours: 'Monday to Sunday, 8am to 11pm')
restaurant2 = Restaurant.create!(restaurant_user_id: restaurant2_user.id,
                                 name: 'restaurant2', cuisines: 'italian',
                                 phone: '435345', email: ' restaurant2@test.com',
                                 location: 'Mostar, Bosnia and Herzegovina',
                                 opening_hours: 'Monday to Sunday, 8am to 11pm')

# Create reservations
reservation1 = Reservation.create!(restaurant_id: restaurant1.id, user_id: guest1_user.id,
                                   status: :created, start_time: DateTime.now,
                                   covers: 4, notes: 'Martini, shaken, not stirred')
