require 'test_helper'

class AuthenticationFlowsTest < ActionDispatch::IntegrationTest
  test 'authentication' do
    get '/api/v1/login'
    assert_response(401)

    post '/api/v1/login'
    assert_response(401)

    post '/api/v1/login', params: {
      username: users(:admin1).username,
      password: Rails.application.credentials.master_password
    }
    assert_response(200)

    token = JSON.parse(response.body)['token']
    authorization = "Bearer #{token}"
    headers = { Authorization: authorization }

    get '/api/v1/login', headers: headers
    assert_response(200)
    username = JSON.parse(response.body)['username']
    assert_equal(users(:admin1).username, username)

  end
end
