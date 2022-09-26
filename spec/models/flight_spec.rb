require 'rails_helper'

RSpec.describe Flight, type: :model do
  describe 'associations' do
    subject { build(:flight) }
    it do
      should belong_to(:departure_airport)
        .class_name('Airport').with_primary_key('code')
        .inverse_of(:departing_flights).dependent(false)
    end
    it do
      should belong_to(:arrival_airport)
        .class_name('Airport').with_primary_key('code')
        .inverse_of(:arriving_flights).dependent(false)
    end
    it { should have_many(:bookings).dependent(:destroy).inverse_of(:flight) }
    it { should have_db_index(:departure_airport_id) }
    it { should have_db_index(:arrival_airport_id) }
  end

  describe 'validations' do
    subject { build(:flight) }

    it { should validate_presence_of(:departure) }
    it { should validate_presence_of(:duration) }
    it {
      should validate_numericality_of(:duration)
        .only_integer.is_greater_than(3600).is_less_than(86_400)
    }
    # TODO: maybe this needs validates associated passengers
  end
end
