require 'rails_helper'

RSpec.describe Booking, type: :model do
  describe 'associations' do
    subject { build(:booking) }
    it { should belong_to(:flight).inverse_of(:bookings).dependent(false) }
    it { should have_many(:passengers).dependent(:destroy).inverse_of(:booking) }
    it { should accept_nested_attributes_for(:passengers).allow_destroy(true).limit(4) }
  end
end
