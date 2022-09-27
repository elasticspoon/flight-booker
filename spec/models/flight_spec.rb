# rubocop:disable Metrics/BlockLength
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

  describe '#pretty_departure' do
    let(:flight) { build_stubbed(:flight) }
    it 'returns a pretty departure date' do
      expect(flight.pretty_departure).to eq(flight.departure.strftime('%m/%d/%Y'))
    end
  end

  describe 'flight duration' do
    it 'returns a duration in hours if time round number' do
      flight = build_stubbed(:flight, duration: 3600)
      expect(flight.pretty_duration).to eq('1 hour')
    end

    it 'returns a duration in hours and minutes' do
      flight = build_stubbed(:flight, duration: 3900)
      expect(flight.pretty_duration).to eq('1 hour 5 minutes')
    end
  end

  describe 'self.departure_collection' do
    let(:flights) { Flight.all }
    context 'when flights are empty' do
      it { expect(Flight.departure_collection(flights)).to be_empty }
    end

    context 'when flights are not empty' do
      let!(:flight) { create(:flight) }
      it { expect(Flight.departure_collection(flights)).to be_a(Array) }
      it { expect(Flight.departure_collection(flights)).to all(be_a(Struct)) }
      it 'returns an array of unique departure dates' do
        Flight.destroy_all
        create(:flight, departure: Time.zone.now.change(hour: 0))
        create(:flight, departure: Time.zone.now.change(hour: 1))

        expect(Flight.departure_collection(flights).size).to eq(1)
      end

      it 'makes the departure date id pretty' do
        time = flight.departure
        pretty_time = time.strftime('%m/%d/%Y')
        departure = Flight.departure_collection(flights).first
        expect(departure.id).to match(pretty_time)
      end

      it 'makes the departure date name pretty' do
        time = flight.departure
        pretty_time = time.strftime('%m/%d/%Y')
        departure = Flight.departure_collection(flights).first
        expect(departure.name).to match(pretty_time)
      end
    end
  end

  describe 'self.departure_range' do
    it 'returns a time range value' do
      expect(Flight.departure_range('01/01/2021')).to be_a(Range)
    end

    it 'returns a range with first value as start of given day' do
      range = Flight.departure_range('01/01/2021')
      start_of_day = Time.zone.parse('01/01/2021').beginning_of_day
      expect(range.first).to eq(start_of_day)
    end

    it 'returns a range with last value as start of next day' do
      range = Flight.departure_range('01/01/2021')
      start_of_next_day = Time.zone.parse('02/01/2021').beginning_of_day
      expect(range.last).to eq(start_of_next_day)
    end

    it 'parses american dates' do
      date = '12/31/2021'
      expect { Flight.departure_range(date) }.not_to raise_error Date::Error
    end
  end
end

# rubocop:enable Metrics/BlockLength
