class Booking < ApplicationRecord
  belongs_to :flight, inverse_of: :bookings, dependent: false
  has_many :passengers, dependent: :destroy, inverse_of: :booking
  accepts_nested_attributes_for :passengers, allow_destroy: true, limit: 4

  validates :passengers, presence: true

  validate :passenger_count

  private

  def passenger_count
    return if passengers.size.between?(1, 4)

    errors.add(:passengers, 'must be between 1 and 4')
  end
end
