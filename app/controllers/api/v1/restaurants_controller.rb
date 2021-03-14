module Api::V1
  class RestaurantsController < ApplicationController
    before_action do
      authorized :admin
    end

    def create
      restaurant = Restaurant.create!(permitted_params)
      render json: restaurant
    end

    def read
      restaurant = Restaurant.find(params[:id])
      render json: restaurant
    end

    def update
      restaurant = Restaurant.update(params[:id], permitted_params)
      render json: restaurant
    end

    def delete
      Restaurant.destroy(params[:id])
      render json: { deleted: true }
    end

    private

    def permitted_params
      params.permit(:name, :cuisines, :phone, :email, :location, :opening_hours)
    end

  end
end
