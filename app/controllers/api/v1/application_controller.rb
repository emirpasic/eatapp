module Api::V1
  class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

    private

    def authorized(*allowed_users_types)
      if !logged_in?
        render json: { message: 'Please log in' }, status: :unauthorized
      elsif !allowed_users_types.include?(@user_type)
        render json: { message: 'Unauthorized' }, status: :forbidden
      end
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
        @user_type = @user.class::TYPE
      end
    end

    def logged_in?
      !!logged_in_user
    end

    def record_not_found
      render json: { message: 'Resource not found' }, status: :not_found
    end

    def record_invalid(err)
      render json: { message: err.to_s }, status: :bad_request
    end
  end
end
