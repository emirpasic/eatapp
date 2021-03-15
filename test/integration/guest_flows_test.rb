require 'test_helper'

class GuestFlowsTest < ActionDispatch::IntegrationTest
  test 'guest' do

    # Log in admin1
    post '/api/v1/login', params: {
      username: users(:admin1).username,
      password: Rails.application.credentials.master_password
    }
    assert_response(200)

    token = JSON.parse(response.body)['token']
    authorization = "Bearer #{token}"
    admin_user_headers = { Authorization: authorization }

    # Log in restaurant1
    post '/api/v1/login', params: {
      username: users(:restaurant1).username,
      password: Rails.application.credentials.master_password
    }
    assert_response(200)

    token = JSON.parse(response.body)['token']
    authorization = "Bearer #{token}"
    restaurant_user_headers = { Authorization: authorization }

    new_guest = {
      username: 'new_guest', password: '123',
      first_name: 'new', last_name: 'guest',
      phone: '123123', email: 'new-guest@test.com'
    }

    # restaurant user not allowed to create guest
    post '/api/v1/guest', params: new_guest, headers: restaurant_user_headers
    assert_response(403)

    # admin user allowed to create guest
    post '/api/v1/guest', params: new_guest, headers: admin_user_headers
    assert_response(200)
    guest_user = JSON.parse(response.body)
    assert_equal(new_guest[:username], guest_user['username'])

    # restaurant user not allowed to get guest
    get "/api/v1/guest/#{guest_user['id']}", headers: restaurant_user_headers
    assert_response(403)

    # non existing user
    get "/api/v1/guest/123123", headers: admin_user_headers
    assert_response(404)

    # admin user allowed to get guest
    get "/api/v1/guest/#{guest_user['id']}", params: new_guest, headers: admin_user_headers
    assert_response(200)
    guest_user = JSON.parse(response.body)
    assert_equal(new_guest[:username], guest_user['username'])
    # ensure password or its digest is not leaked
    assert_nil(guest_user['password'])
    assert_nil(guest_user['password_digest'])

    # restaurant user not allowed to update guest
    first_name = 'John'
    post "/api/v1/guest/#{guest_user['id']}", params: { first_name: first_name }, headers: restaurant_user_headers
    assert_response(403)

    # admin user allowed to update guest
    post "/api/v1/guest/#{guest_user['id']}", params: { first_name: first_name }, headers: admin_user_headers
    assert_response(200)
    guest_user = JSON.parse(response.body)
    assert_equal(first_name, guest_user['first_name'])

    # existing user (newly created)
    get "/api/v1/guest/#{guest_user['id']}", headers: admin_user_headers
    assert_response(200)

    # restaurant user not allowed to delete guest
    delete "/api/v1/guest/#{guest_user['id']}", headers: restaurant_user_headers
    assert_response(403)

    # admin user allowed to delete guest
    delete "/api/v1/guest/#{guest_user['id']}", headers: admin_user_headers
    assert_response(200)

    # deleted user
    get "/api/v1/guest/#{guest_user['id']}", headers: admin_user_headers
    assert_response(404)
  end
end
