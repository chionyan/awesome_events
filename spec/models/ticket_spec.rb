require 'rails_helper'

RSpec.describe Ticket, type: :model do
  describe 'associetion' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:event) }
  end

  describe '#comment' do
    it { should validate_length_of(:comment).is_at_most(30) }
    it { should allow_value('').for(:comment) }
  end
end
