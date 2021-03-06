module Api::V1
  class UsersController < ApplicationController
    before_action only: [:verify_login] do
      authorized :guest, :restaurant, :admin
    end

    def login
      @user = User.find_by(username: params[:username])

      if @user&.authenticate(params[:password])
        exp = Time.now.to_i + Rails.application.config.jwt_expiration_time
        token = encode_token({ user_id: @user.id, exp: exp })
        render json: { user: @user, token: token }
      else
        render json: { error: 'Invalid/missing username or password' }, status: :unauthorized
      end
    end

    def verify_login
      render json: @user
    end
  end
end