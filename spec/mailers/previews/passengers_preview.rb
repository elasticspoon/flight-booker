# Preview all emails at http://localhost:3000/rails/mailers/passengers
class PassengersPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/passengers/new_passenger
  def new_passenger
    PassengersMailer.new_passenger
  end

end
