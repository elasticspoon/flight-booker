class Passenger < ApplicationRecord
  belongs_to :booking, inverse_of: :passengers, dependent: false
  has_one :flight, through: :booking

  validates :name, presence: true
  validates :email, presence: true
end
