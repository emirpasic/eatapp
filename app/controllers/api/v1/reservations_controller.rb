module Api::V1
  class ReservationsController < ApplicationController
    before_action do
      authorized :guest, :restaurant, :admin
    end

    def create
      ActiveRecord::Base.transaction do

        restaurant = Restaurant.find_by(id: params[:restaurant_id])
        raise ActiveRecord::RecordNotFound, 'Restaurant not found' unless restaurant

        guest = GuestUser.find_by(id: params[:user_id])
        raise ActiveRecord::RecordNotFound, 'Guest not found' unless guest

        is_restaurant_manager = restaurant_user? &&
          restaurant.restaurant_user_id == @user.id

        is_guest_self_reservation = guest_user? &&
          params[:user_id] == @user.id

        unless admin_user? || is_restaurant_manager || is_guest_self_reservation
          render json: { message: 'Unauthorized' }, status: :forbidden and return
        end

        reservation = Reservation.create!(
          permitted_params.merge(status: :created) # enforce status - created
        )
        render json: reservation
      end
    end

    def read
      ActiveRecord::Base.transaction do
        reservation = Reservation.find(params[:id])
        restaurant = Restaurant.find(reservation.restaurant_id)

        is_restaurant_manager = restaurant_user? &&
          restaurant.restaurant_user_id == @user.id

        is_guest_self_reservation = guest_user? &&
          reservation.user_id == @user.id

        unless admin_user? || is_restaurant_manager || is_guest_self_reservation
          render json: { message: 'Unauthorized' }, status: :forbidden and return
        end

        render json: reservation
      end
    end

    def update
      ActiveRecord::Base.transaction do
        reservation = Reservation.find(params[:id])
        restaurant = Restaurant.find(reservation.restaurant_id)

        is_restaurant_manager = restaurant_user? &&
          restaurant.restaurant_user_id == @user.id

        is_guest_self_reservation = guest_user? &&
          reservation.user_id == @user.id

        unless admin_user? || is_restaurant_manager || is_guest_self_reservation
          render json: { message: 'Unauthorized' }, status: :forbidden and return
        end

        reservation = Reservation.update(params[:id],
                                         # Can't change reservation to antoher user or restaurant
                                         permitted_params.exclude(:restaurant_id, :user_id))
        render json: reservation
      end
    end

    def delete
      ActiveRecord::Base.transaction do
        reservation = Reservation.find(params[:id])
        restaurant = Restaurant.find(reservation.restaurant_id)

        is_restaurant_manager = restaurant_user? &&
          restaurant.restaurant_user_id == @user.id

        is_guest_self_reservation = guest_user? &&
          reservation.user_id == @user.id

        unless admin_user? || is_restaurant_manager || is_guest_self_reservation
          render json: { message: 'Unauthorized' }, status: :forbidden and return
        end

        Reservation.destroy(params[:id])
        render nothing: true
      end
    end

    private

    def permitted_params
      params.permit(:restaurant_id, :user_id, :status, :start_time, :covers, :notes)
    end
  end
end
