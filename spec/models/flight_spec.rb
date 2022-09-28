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
      it { expect(Flight.departure_collection(flights)).to all(be_a(String)) }
      it 'returns an array of unique departure dates' do
        Flight.destroy_all
        create(:flight, departure: Time.zone.now.change(hour: 0))
        create(:flight, departure: Time.zone.now.change(hour: 1))
      end

      it 'makes the departure dates pretty' do
        time = flight.departure
        pretty_time = time.strftime('%m/%d/%Y')
        expect(Flight.departure_collection(flights)).to match([pretty_time])
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
      expect { Flight.departure_range(date) }.not_to raise_error
    end
  end

  describe 'self.parse flights' do
    context 'when flights are empty' do
      it { expect(Flight.parse_flights([])).to be_a(Hash) }
      it { expect(Flight.parse_flights([])).to all(be_a(Array)) }
    end
    context 'when flights are not empty' do
      let(:flights) { ['01/01/2021', '01/01/2021', '01/02/2021'] }
      it { expect(Flight.parse_flights([])).to be_a(Hash) }
      it { expect(Flight.parse_flights([])).to all(be_a(Array)) }
      it 'returns a hash with keys month, day, year' do
        expect(Flight.parse_flights(flights).keys).to match(%i[month day year])
      end
      it 'has a the correct value for days' do
        expect(Flight.parse_flights(flights)[:day]).to match(%w[01 01 02])
      end
      it 'has a the correct value for months' do
        expect(Flight.parse_flights(flights)[:month]).to match(%w[01 01 01])
      end
      it 'has a the correct value for years' do
        expect(Flight.parse_flights(flights)[:year]).to match(%w[2021 2021 2021])
      end
    end
  end
  describe 'self.parse_date_params' do
    let(:params) { ActionController::Parameters.new(param_values) }
    context 'when params are bad' do
      it 'returns nil if not given params' do
        expect(Flight.parse_date_params(nil)).to be_nil
      end
      context 'when params are empty' do
        let(:param_values) { {} }
        it { expect(Flight.parse_date_params(params)).to be_nil }
      end
      context 'when no params are given' do
        let(:param_values) { { month: '', day: '', year: '' } }
        it { expect(Flight.parse_date_params(params)).to be_nil }
      end
      context 'when params are m d' do
        let(:param_values) { { month: '01', day: '01', year: '' } }
        it { expect(Flight.parse_date_params(params)).to be_nil }
      end
      context 'when params are y d' do
        let(:param_values) { { month: '', day: '01', year: '2021' } }
        it { expect(Flight.parse_date_params(params)).to be_nil }
      end
      context 'when params are m' do
        let(:param_values) { { month: '01', day: '', year: '' } }
        it { expect(Flight.parse_date_params(params)).to be_nil }
      end
      context 'when params are d' do
        let(:param_values) { { month: '', day: '01', year: '' } }
        it { expect(Flight.parse_date_params(params)).to be_nil }
      end
    end
    context 'when params are good' do
      let(:param_values) { { month: '01', day: '01', year: '2021' } }
      it 'returns a range of dates' do
        expect(Flight.parse_date_params(params)).to be_a(Range)
      end
      context 'when params have y m d' do
        let(:param_values) { { month: '01', day: '01', year: '2021' } }
        it 'returns a range with start on expected day' do
          date_range = Flight.parse_date_params(params)
          expect(date_range.first).to eq(Time.zone.parse('01/01/2021'))
        end
        it 'returns a range with end on next day' do
          date_range = Flight.parse_date_params(params)
          expect(date_range.last).to eq(Time.zone.parse('02/01/2021'))
        end
      end
      context 'when params have y m' do
        let(:param_values) { { day: '', month: '01', year: '2021' } }
        it 'returns a range with start on expected day' do
          date_range = Flight.parse_date_params(params)
          expect(date_range.first).to eq(Time.zone.parse('01/01/2021'))
        end
        it 'returns a range with end on next month' do
          date_range = Flight.parse_date_params(params)
          expect(date_range.last).to eq(Time.zone.parse('01/02/2021'))
        end
      end
      context 'when params have y' do
        let(:param_values) { { day: '', month: '', year: '2021' } }
        it 'returns a range with start on expected day' do
          date_range = Flight.parse_date_params(params)
          expect(date_range.first).to eq(Time.zone.parse('01/01/2021'))
        end
        it 'returns a range with end on next year' do
          date_range = Flight.parse_date_params(params)
          expect(date_range.last).to eq(Time.zone.parse('01/01/2022'))
        end
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
