class PassengersMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.passengers_mailer.new_passenger.subject
  #

  def new_passenger
    @passenger = params[:passenger]
    @flight = params[:flight]

    return unless @passenger

    mail to: @passenger.email
  end
end
