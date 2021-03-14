class UsersController < ApplicationController
  before_action :authorized, only: [:verify_login]

  def login
    @user = User.find_by(username: params[:username])

    if @user&.authenticate(params[:password])
      exp = Time.now.to_i + Rails.application.config.jwt_expiration_time
      token = encode_token({ user_id: @user.id, exp: exp })
      render json: { user: @user, token: token }
    else
      render json: { error: 'Invalid username or password' }
    end
  end

  def verify_login
    render json: @user
  end
end
