class User < ApplicationRecord
  has_many :reservations, dependent: :destroy

  has_secure_password

  validates :username, presence: true
  validates :password_digest, presence: true
end
