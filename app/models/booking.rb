class Booking < ApplicationRecord
  belongs_to :flight, inverse_of: :bookings, dependent: false
  has_many :passengers, dependent: :destroy, inverse_of: :booking
  accepts_nested_attributes_for :passengers, allow_destroy: true, limit: 4

  validate :passenger_count

  before_validation :passenger_removal

  validates_associated :passengers

  private

  def custom_validations
    passenger_count
    passenger_removal
  end

  def passenger_removal
    errors.add(:base, 'Must have at least one passenger') if passengers.reject(&:marked_for_destruction?).empty?
  end

  def passenger_count
    errors.add(:passengers, 'must be between 1 and 4') unless passengers.size.between?(1, 4)
  end
end
