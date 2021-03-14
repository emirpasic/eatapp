class Restaurant < ApplicationRecord
  has_many :reservations, dependent: :destroy
  belongs_to :user, foreign_key: 'restaurant_user_id'

  validates :name, presence: true
  validates :cuisines, presence: true
  validates :phone, presence: true
  validates :email, presence: true
  validates :location, presence: true
  validates :opening_hours, presence: true
end
