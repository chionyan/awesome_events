require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'association' do
    it { is_expected.to belong_to(:owner) }
    it { is_expected.to have_many(:tickets).dependent(:destroy) }
    it { is_expected.to have_many(:users) }
  end

  describe '#name' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }
  end

  describe '#place' do
    it { should validate_presence_of(:place) }
    it { should validate_length_of(:place).is_at_most(100) }
  end

  describe '#content' do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(2000) }
  end

  describe '#start_time' do
    it { should validate_presence_of(:start_time) }
  end

  describe '#end_time' do
    it { should validate_presence_of(:end_time) }
  end

  describe '#start_time_should_be_before_end_time' do
    let!(:event) { build(:event) }

    context 'start_time が end_time 以上の時' do
      before { event.start_time = event.end_time }
      it { expect(event).to_not be_valid }
    end

    context 'start_time が end_time 未満の時' do
      it { expect(event).to be_valid }
    end
  end
end
