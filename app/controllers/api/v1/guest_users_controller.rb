module Api
  module V1
    class GuestUsersController < ApplicationController
      before_action do
        authorized :admin
      end

      def create
        guest_user = GuestUser.create!(permitted_params)
        render json: output(guest_user)
      end

      def read
        guest_user = GuestUser.find(params[:id])
        render json: output(guest_user)
      end

      def update
        guest_user = GuestUser.update(params[:id], permitted_params)
        render json: output(guest_user)
      end

      def delete
        GuestUser.destroy(params[:id])
        render nothing: true
      end

      private

      def permitted_params
        params.permit(:username, :password, :first_name, :last_name, :phone, :email)
      end

      def output(user)
        user.as_json(except: [:password_digest])
      end

    end
  end
end
