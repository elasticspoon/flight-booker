# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Flights', type: :system do
  before do
    driven_by(:rack_test)
  end

  it 'shows no flights if there are none' do
    visit flights_path
    expect(page.has_css?('.flight')).to be false
  end

  context 'with flights' do
    let(:airports) { create_list(:airport, 3) }
    let(:flight) do
      create(:flight, departure_airport: airports[0], arrival_airport: airports[1], departure: Date.parse('2020-01-01'))
    end
    before do
      create(:flight, departure_airport: airports[0], arrival_airport: airports[2], departure: flight.departure)
      create(
        :flight,
        departure_airport: airports[0],
        arrival_airport:   airports[1],
        departure:         flight.departure + 1.year
      )
      create(
        :flight,
        departure_airport: airports[0],
        arrival_airport:   airports[1],
        departure:         flight.departure + 1.month
      )
      create(:flight, departure_airport: airports[0], arrival_airport: airports[1], departure: flight.departure + 1.day)
    end

    it 'shows no flights if there are flights when landing on flights page' do
      visit flights_path
      expect(page.has_css?('.flight')).to be false
    end

    it 'allows the user to narrow down flights' do
      visit flights_path
      expect(page).to have_css('.flight', count: 0)

      select airports[0].location, from: 'departure_airport'
      click_button 'Search'
      expect(page).to have_css('.flight', count: 5)

      select airports[1].location, from: 'arrival_airport'
      click_button 'Search'
      expect(page).to have_css('.flight', count: 4)

      select flight.departure.year, from: 'departure[year]'
      click_button 'Search'
      expect(page).to have_css('.flight', count: 3)

      select flight.departure.month, from: 'departure[month]'
      click_button 'Search'
      expect(page).to have_css('.flight', count: 2)

      select flight.departure.day, from: 'departure[day]'
      click_button 'Search'
      expect(page).to have_css('.flight', count: 1)
    end
  end

  describe 'can reach booking' do
    let!(:flight) { create(:flight) }
    it 'can reach booking page' do
      visit flights_path
      select flight.departure_airport.location, from: 'departure_airport'
      click_button 'Search'
      click_button 'Select Flight'
      expect(page.has_content?('Name')).to be true
    end

    it 'creates more passengers' do
      visit flights_path
      select flight.departure_airport.location, from: 'departure_airport'
      select '2', from: 'num_passengers'
      click_button 'Search'
      click_button 'Select Flight'
      expect(page.has_content?('Name', count: 2)).to be true
    end
  end
end
# rubocop:enable Metrics/BlockLength
