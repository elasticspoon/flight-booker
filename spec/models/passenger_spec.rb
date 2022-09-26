require 'rails_helper'

RSpec.describe Passenger, type: :model do
  describe 'associations' do
    subject { build(:passenger) }
    it { should belong_to(:booking).inverse_of(:passengers).dependent(false) }
    it { should have_one(:flight).through(:booking) }
  end

  describe 'validations' do
    subject { build(:passenger) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
  end
end
