module Api::V1
  class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ArgumentError, with: :record_invalid

    def authorized(*allowed_users_types)
      if !logged_in?
        render json: { message: 'Please log in' }, status: :unauthorized
      else
        is_admin = allowed_users_types.include?(:admin) && admin_user?
        is_restaurant = allowed_users_types.include?(:restaurant) && restaurant_user?
        is_guest = allowed_users_types.include?(:guest) && guest_user?
        unless is_admin || is_restaurant || is_guest
          render json: { message: 'Unauthorized' }, status: :forbidden
        end
      end
    end

    def admin_user?
      @user&.is_a?(AdminUser)
    end

    def restaurant_user?
      @user&.is_a?(RestaurantUser)
    end

    def guest_user?
      @user&.is_a?(GuestUser)
    end

    private

    def encode_token(payload)
      JWT.encode(payload, Rails.application.credentials.jwt_secret)
    end

    def auth_header
      # { Authorization: 'Bearer <token>' }
      request.headers['Authorization']
    end

    def decoded_token
      if auth_header
        token = auth_header.split(' ')[1]
        # header: { 'Authorization': 'Bearer <token>' }
        begin
          JWT.decode(token, Rails.application.credentials.jwt_secret, true,
                     { algorithm: 'HS256', verify_expiration: true })
        rescue JWT::DecodeError
          nil
        end
      end
    end

    def logged_in_user
      # Keep for current request
      return @user if @user

      if decoded_token
        user_id = decoded_token[0]['user_id']
        @user = User.find_by(id: user_id)
      end
    end

    def logged_in?
      !!logged_in_user
    end

    def record_not_found(err)
      render json: { message: err.to_s }, status: :not_found
    end

    def record_invalid(err)
      render json: { message: err.to_s }, status: :bad_request
    end
  end
end
