# rubocop:disable Metrics/BlockLength
require 'rails_helper'

RSpec.describe 'Bookings', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:num_passengers) { 2 }
  let(:flight) { create(:flight) }

  let(:booking) do
    create_booking_with_passengers(passenger_count: num_passengers)
  end

  describe 'new booking' do
    let(:num_passengers) { 2 }

    before do
      visit new_booking_path(booking: { flight_id: flight.id, num_passengers: })
    end

    it 'has page content' do
      expect(page.has_content?('Name', count: 2)).to be true
      expect(page.has_content?('Email', count: 2)).to be true
      expect(page.has_button?('Create Booking')).to be true
      expect(page.has_button?('Add a passenger')).to be true
      expect(page.has_button?('Remove a passenger')).to be true
    end

    it 'can add passenger' do
      click_button('Add a passenger')
      expect(page.has_content?('Name', count: 3)).to be true
    end

    it 'can remove passenger' do
      click_button('Remove a passenger')
      expect(page.has_content?('Name', count: 1)).to be true
    end
    context 'with one passenger' do
      let(:num_passengers) { 1 }

      it 'creates a new booking' do
        fill_in 'Name', with: 'John Doe'
        fill_in 'Email', with: 'some email'
        click_button 'Create Booking'

        expect(page).to have_content('Booking was successfully created.')
        expect(Booking.count).to eq(1)
        expect(Passenger.count).to eq(1)
        expect(page.current_path).to eq(booking_path(Booking.last))
      end

      it 'hides remove passenger button when only one passenger' do
        expect(page.has_button?('Remove a passenger')).to be false
      end
    end

    context 'with 4 passengers' do
      let(:num_passengers) { 4 }
      it 'hides add passenger button when 4 passengers' do
        expect(page.has_button?('Add a passenger')).to be false
      end
    end
  end

  describe 'edit booking' do
    it 'has page components' do
      visit edit_booking_path(booking)

      expect(page.has_css?('.flight')).to be true
      expect(page.has_content?('Name', count: 2)).to be true
      expect(page.has_button?('Update Booking')).to be true
      expect(page.has_link?('Show this booking')).to be true
      expect(page.has_link?('Back to flights')).to be true
    end

    it 'can remove a passenger' do
      visit edit_booking_path(booking)

      expect(page.has_content?('Name', count: 2)).to be true

      check 'booking_passengers_attributes_0__destroy'
      click_button 'Update Booking'

      expect(page.has_content?('Name', count: 1)).to be true
    end

    it 'must have at least one passenger' do
      visit edit_booking_path(booking)

      expect(page.has_content?('Name', count: 2)).to be true

      check 'booking_passengers_attributes_0__destroy'
      check 'booking_passengers_attributes_1__destroy'
      click_button 'Update Booking'

      expect(page.has_content?('error')).to be true
    end
  end

  describe 'show booking' do
    it 'has correct page contents' do
      visit booking_path(booking)

      expect(page.has_css?('.flight')).to be true
      expect(page.has_content?('Name', count: 2)).to be true
      expect(page.has_button?('Destroy this booking')).to be true
      expect(page.has_link?('Edit this booking')).to be true
      expect(page.has_link?('Back to flights')).to be true
    end

    it 'can delete a booking' do
      visit booking_path(booking)
      click_button 'Destroy this booking'
      expect(page).to have_content('Booking was successfully destroyed.')
      expect(page).to have_current_path(flights_path)
      expect(Booking.exists?(id: booking.id)).not_to be true
    end

    it 'has a link to edit a booking' do
      visit booking_path(booking)
      click_link 'Edit this booking'
      expect(page).to have_current_path(edit_booking_path(booking))
    end

    it 'has a link to go back to flights' do
      visit booking_path(booking)
      click_link 'Back to flights'
      expect(page).to have_current_path(flights_path)
    end
  end
end
# rubocop:enable Metrics/BlockLength
