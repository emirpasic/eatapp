class Restaurant < ApplicationRecord
  validates :name, presence: true
  validates :cuisines, presence: true
  validates :phone, presence: true
  validates :email, presence: true
  validates :location, presence: true
  validates :opening_hours, presence: true
end
