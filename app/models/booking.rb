class Booking < ApplicationRecord
  belongs_to :flight, inverse_of: :bookings, dependent: false
  has_many :passengers, dependent: :destroy, inverse_of: :booking
  accepts_nested_attributes_for :passengers, allow_destroy: true, limit: 4
end
