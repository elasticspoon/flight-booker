require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'associations' do
    subject { build(:booking) }
    it { should belong_to(:flight).inverse_of(:bookings).dependent(false) }
    it { should have_many(:passengers).dependent(:destroy).inverse_of(:booking) }
    it { should accept_nested_attributes_for(:passengers).allow_destroy(true).limit(4) }
  end

  describe 'validations' do
    let(:booking) { build(:booking) }
    subject { booking }
    it { should validate_presence_of(:passengers) }

    it 'should not allow more than 4 passengers' do
      booking = build_booking_with_passengers(passenger_count: 5)
      expect(booking).not_to be_valid
    end

    it 'should not allow less than 1 passenger' do
      booking = build_booking_with_passengers(passenger_count: 0)
      expect(booking).not_to be_valid
    end

    it 'should allow passengers' do
      booking = build_booking_with_passengers(passenger_count: 2)
      expect(booking).to be_valid
    end
  end
end
