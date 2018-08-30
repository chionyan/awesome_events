require 'rails_helper'

RSpec.describe 'RetireSystem', type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user, :user_2) }

  before do
    travel_to '2018-07-07 18:30:00'
    OmniAuth.config.mock_auth[:twitter] = log_in_as user
    visit '/'
    click_link 'Twitterでログイン'
    click_link 'AwesomeEvents'
  end

  it '"退会"ボタンが表示されること' do
    expect(page).to have_content '退会'
  end

  describe '”退会"ボタンを押した時' do
    before { click_link '退会' }

    it '正しくページが表示されること' do
      aggregate_failures do
        expect(page).to have_content '退会の確認'
        expect(page).to have_link '退会する'
      end
    end
  end

  describe '”退会する"ボタンを押した時' do
    subject { click_link '退会する' }

    before { click_link '退会' }

    context '公開中の未終了イベントも未終了の参加イベントもない場合' do
      it 'トップページに遷移すること' do
        subject
        expect(page.current_path).to eq '/'
      end

      it '"退会完了しました" メッセージが表示されていること' do
        subject
        expect(page).to have_content '退会完了しました'
      end
    end

    context '公開中の未終了イベントがある場合' do
      let!(:future_event) { create(:event, :future_event, owner: user) }

      it '"公開中の未終了イベントが存在します。" メッセージが表示されていること' do
        subject
        expect(page).to have_content '公開中の未終了イベントが存在します。'
      end
    end

    context '未終了の参加イベントがある場合' do
      let!(:future_event) { create(:event, :future_event, owner: other_user) }
      let!(:ticket) { create(:ticket, user: user, event: future_event) }

      it '"未終了の参加イベントが存在します。" メッセージが表示されていること' do
        subject
        expect(page).to have_content '未終了の参加イベントが存在します。'
      end
    end
  end
end
