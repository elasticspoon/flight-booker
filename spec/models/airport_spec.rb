# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe Airport, type: :model do
  describe 'associations' do
    subject { build(:airport) }

    it do
      should have_many(:departing_flights)
        .class_name('Flight').with_foreign_key('departure_airport_id')
        .inverse_of(:departure_airport).dependent(:destroy)
    end
    it do
      should have_many(:arriving_flights)
        .class_name('Flight').with_foreign_key('arrival_airport_id')
        .inverse_of(:arrival_airport).dependent(:destroy)
    end
  end

  describe 'validations' do
    subject { build(:airport) }

    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
    it { should validate_length_of(:code).is_equal_to(3) }
    it { should validate_presence_of(:location) }
    describe 'code format' do
      it { should allow_value('ABC').for(:code) }
      it { should_not allow_value('abc').for(:code) }
      it { should_not allow_value('A B').for(:code) }
      it { should_not allow_value('AB1').for(:code) }
      it { should_not allow_value('$%^').for(:code) }
    end
  end
end

# rubocop:enable Metrics/BlockLength
