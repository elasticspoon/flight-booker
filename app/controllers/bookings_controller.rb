class BookingsController < ApplicationController
  before_action :set_booking, only: %i[show edit update destroy]
  before_action :build_booking, only: :new
  after_action :mail_new_passengers, only: :create

  # GET /bookings/1 or /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings or /bookings.json
  def create
    @booking = Booking.new(booking_params)

    respond_to do |format|
      if @booking.save
        format.html { redirect_to booking_url(@booking), notice: 'Booking was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1 or /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to booking_url(@booking), notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1 or /bookings/1.json
  def destroy
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to flights_path, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_booking
    @booking = Booking.find(params[:id])
  end

  def build_booking
    params = booking_params
    booking = Booking.new(flight_id: params[:flight_id])
    params[:num_passengers].to_i.times { booking.passengers.build }
    @booking = booking
  end

  # Only allow a list of trusted parameters through.
  def booking_params
    params.require(:booking).permit(:flight_id, :num_passengers, :id, passengers_attributes: %i[id name email _destroy])
  end

  def mail_new_passengers
    booking = @booking
    flight = booking.flight
    booking.passengers.each do |passenger|
      PassengersMailer.with(passenger:, flight:).new_passenger.deliver_later
    end
  end
end
