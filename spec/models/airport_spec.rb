require 'rails_helper'

RSpec.describe Airport, type: :model do
  describe 'associations' do
    subject { build(:airport) }

    it do
      should have_many(:departing_flights)
        .class_name('Flight').with_foreign_key('departure_airport_id')
        .inverse_of(:departure_airport).dependent(false)
    end
    it do
      should have_many(:arriving_flights)
        .class_name('Flight').with_foreign_key('arrival_airport_id')
        .inverse_of(:arrival_airport).dependent(false)
    end
  end

  describe 'validations' do
    subject { build(:airport) }

    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
    it { should validate_length_of(:code).is_equal_to(3) }
    it { should validate_presence_of(:location) }
  end
end
