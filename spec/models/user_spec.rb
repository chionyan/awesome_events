require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'association' do
    it { is_expected.to have_many(:created_events) }
    it { is_expected.to have_many(:tickets) }
    it { is_expected.to have_many(:events) }
  end
end
