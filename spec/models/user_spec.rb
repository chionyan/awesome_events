require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'association' do
    it { is_expected.to have_many(:created_events) }
    it { is_expected.to have_many(:tickets) }
    it { is_expected.to have_many(:events) }
    it { is_expected.to have_many(:participating_events) }
  end

  describe '#check_all_events_finished' do
    subject { user.send(:check_all_events_finished) }

    let!(:user) { build(:user) }
    let!(:other_user) { create(:user, :user_2) }

    before do
      OmniAuth.config.mock_auth[:twitter] = log_in_as user
      allow(Time.zone).to receive(:now).and_return('2018-07-07 11:30:00'.to_datetime)
    end

    context '公開中の未終了イベントも未終了の参加イベントもない場合' do
      it { expect(subject).to eq true }
    end

    context '公開中の未終了イベントがある場合' do
      let!(:future_event) { create(:event, :future_event, owner: user) }

      it { expect(subject).to eq false }
    end

    context '未終了の参加イベントがある場合' do
      let!(:future_event) { create(:event, :future_event, owner: other_user) }
      let!(:ticket) { create(:ticket, user: user, event: future_event) }

      it { expect(subject).to eq false }
    end
  end
end
