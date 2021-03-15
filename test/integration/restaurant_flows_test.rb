require 'test_helper'

class RestaurantFlowsTest < ActionDispatch::IntegrationTest
  test 'restaurant' do

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
    restaurant1_user_id = JSON.parse(response.body)['user']['id']

    new_restaurant1 = {
      restaurant_user_id: restaurant1_user_id,
      name: 'restaurant1', cuisines: 'italian',
      phone: '435345', email: ' restaurant2@test.com',
      location: 'Mostar, Bosnia and Herzegovina',
      opening_hours: 'Monday to Sunday, 8am to 11pm'
    }

    # restaurant user not allowed to create restaurant
    post '/api/v1/restaurant', params: new_restaurant1, headers: restaurant1_user_headers
    assert_response(403)

    # admin user allowed to create restaurant
    post '/api/v1/restaurant', params: new_restaurant1, headers: admin1_user_headers
    assert_response(200)
    new_restaurant = JSON.parse(response.body)
    assert_equal(new_restaurant1[:name], new_restaurant['name'])

    # restaurant user not allowed to get restaurant
    get "/api/v1/restaurant/#{new_restaurant['id']}", headers: restaurant1_user_headers
    assert_response(403)

    # non existing restaurant
    get "/api/v1/restaurant/123123", headers: admin1_user_headers
    assert_response(404)

    # admin user allowed to get restaurant
    get "/api/v1/restaurant/#{new_restaurant['id']}", headers: admin1_user_headers
    assert_response(200)
    new_restaurant = JSON.parse(response.body)
    assert_equal(new_restaurant1[:name], new_restaurant['name'])

    # restaurant user not allowed to update restaurant
    name = 'New name'
    post "/api/v1/restaurant/#{new_restaurant['id']}", params: { name: name }, headers: restaurant1_user_headers
    assert_response(403)

    # admin user allowed to update restaurant
    post "/api/v1/restaurant/#{new_restaurant['id']}", params: { name: name }, headers: admin1_user_headers
    assert_response(200)
    new_restaurant = JSON.parse(response.body)
    assert_equal(name, new_restaurant['name'])

    # existing user (newly created)
    get "/api/v1/restaurant/#{new_restaurant['id']}", headers: admin1_user_headers
    assert_response(200)

    # restaurant user not allowed to delete restaurant
    delete "/api/v1/restaurant/#{new_restaurant['id']}", headers: restaurant1_user_headers
    assert_response(403)

    # admin user allowed to delete restaurant
    delete "/api/v1/restaurant/#{new_restaurant['id']}", headers: admin1_user_headers
    assert_response(200)

    # deleted user
    get "/api/v1/restaurant/#{new_restaurant['id']}", headers: admin1_user_headers
    assert_response(404)
  end
end
