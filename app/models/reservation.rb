class Reservation < ApplicationRecord
  belongs_to :restaurant
  belongs_to :user

  enum status: %i[created booked canceled]

  validates :status, presence: true
  validates :start_time, presence: true
  validates :covers, presence: true
end
