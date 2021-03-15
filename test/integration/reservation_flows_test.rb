require 'test_helper'

class ReservationFlowsTest < ActionDispatch::IntegrationTest
  test 'reservation' do
    # Log in admin1
    post '/api/v1/login', params: {
      username: users(:admin1).username,
      password: Rails.application.credentials.master_password
    }
    assert_response(200)

    token = JSON.parse(response.body)['token']
    authorization = "Bearer #{token}"
    admin1_user_headers = { Authorization: authorization }

    # Log in restaurant1
    post '/api/v1/login', params: {
      username: users(:restaurant1).username,
      password: Rails.application.credentials.master_password
    }
    assert_response(200)

    token = JSON.parse(response.body)['token']
    authorization = "Bearer #{token}"
    restaurant1_user_headers = { Authorization: authorization }

    # Log in restaurant2
    post '/api/v1/login', params: {
      username: users(:restaurant2).username,
      password: Rails.application.credentials.master_password
    }
    assert_response(200)

    token = JSON.parse(response.body)['token']
    authorization = "Bearer #{token}"
    restaurant2_user_headers = { Authorization: authorization }

    # Log in guest1
    post '/api/v1/login', params: {
      username: users(:guest1).username,
      password: Rails.application.credentials.master_password
    }
    assert_response(200)

    token = JSON.parse(response.body)['token']
    authorization = "Bearer #{token}"
    guest1_user_headers = { Authorization: authorization }
    guest1_user_id = JSON.parse(response.body)['user']['id']

    # Log in guest2
    post '/api/v1/login', params: {
      username: users(:guest2).username,
      password: Rails.application.credentials.master_password
    }
    assert_response(200)

    token = JSON.parse(response.body)['token']
    authorization = "Bearer #{token}"

    new_restaurant1 = {
      restaurant_user_id: users(:restaurant1).id,
      name: 'restaurant1', cuisines: 'italian',
      phone: '435345', email: ' restaurant2@test.com',
      location: 'Mostar, Bosnia and Herzegovina',
      opening_hours: 'Monday to Sunday, 8am to 11pm'
    }

    # admin user allowed to create restaurant
    post '/api/v1/restaurant', as: :json, params: new_restaurant1, headers: admin1_user_headers
    assert_response(200)
    new_restaurant = JSON.parse(response.body)
    assert_equal(new_restaurant1[:name], new_restaurant['name'])

    new_reservation1 = {
      restaurant_id: new_restaurant['id'], user_id: guest1_user_id,
      start_time: DateTime.now,
      covers: 4, notes: 'Martini, shaken, not stirred'
    }

    # guest self reservation (ok)
    post '/api/v1/reservation', as: :json, params: new_reservation1, headers: guest1_user_headers
    assert_response(200)
    guest_self_reservation = JSON.parse(response.body)

    # guest self reservation but for a different user (not ok)
    post '/api/v1/reservation', as: :json, params: new_reservation1.merge({ user_id: users(:guest2).id }),
         headers: guest1_user_headers
    assert_response(403)

    # restaurant1_user reservation for own restaurant (ok)
    post '/api/v1/reservation', as: :json, params: new_reservation1, headers: restaurant1_user_headers
    assert_response(200)

    # restaurant1_user reservation for non-existing restaurant (ok)
    post '/api/v1/reservation', as: :json, params: new_reservation1.merge({ restaurant_id: 123 }),
         headers: restaurant1_user_headers
    assert_response(404)

    # allow admin to update reservation
    new_status = :booked
    post "/api/v1/reservation/#{guest_self_reservation['id']}", as: :json, params: { status: new_status },
         headers: admin1_user_headers
    assert_equal('booked', JSON.parse(response.body)['status'])

    # admin to update reservation status to invalid status
    new_status = :not_valid_status
    post "/api/v1/reservation/#{guest_self_reservation['id']}", as: :json, params: { status: new_status },
         headers: admin1_user_headers
    assert_response(400)

    # allow restaurant1_user to update reservation for own restaurant
    new_status = :canceled
    post "/api/v1/reservation/#{guest_self_reservation['id']}", as: :json, params: { status: new_status },
         headers: restaurant1_user_headers
    assert_response(200)
    assert_equal('canceled', JSON.parse(response.body)['status'])

    # disallow restaurant2_user to update reservation for somebody else's restaurant
    new_status = :canceled
    post "/api/v1/reservation/#{guest_self_reservation['id']}", as: :json, params: { status: new_status },
         headers: restaurant2_user_headers
    assert_response(403)

    # delete guest self reservation (ok)
    delete "/api/v1/reservation/#{guest_self_reservation['id']}", as: :json, headers: guest1_user_headers
    assert_response(200)

    # fail fetching deleted reservation (ok)
    get "/api/v1/reservation/#{guest_self_reservation['id']}", as: :json, headers: guest1_user_headers
    assert_response(404)
  end
end
