class PassengersMailerPreview < ActionMailer::Preview
  def new_passenger
    booking = Booking.first
    flight = booking.flight
    passenger = booking.passengers.first
    PassengersMailer.with(passenger:, flight:).new_passenger
  end
end
