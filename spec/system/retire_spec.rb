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

  describe 'ユーザが退会した時' do
    subject do
      travel_to '2018-07-07 17:00:00'
      click_link 'AwesomeEvents'
      click_link past_event.name
    end

    before do
      travel_to '2018-07-07 23:00:00'
      click_link '退会'
    end

    context '主催者が退会した場合' do
      let!(:past_event) { create(:event, :past_event, owner: user) }

      before { click_link '退会する' }

      it '主催者に"退会したユーザです"が表示されること' do
        subject
        organizer = page.find(:css, 'div:nth-child(1) > div.card-body')
        expect(organizer.text).to eq '退会したユーザです'
      end
    end

    context '参加者が退会した場合' do
      let!(:past_event) { create(:event, :past_event, owner: other_user) }
      let!(:ticket) { create(:ticket, user: user, event: past_event) }

      before { click_link '退会する' }

      it '参加者に"退会したユーザです"が表示されること' do
        subject
        list_group = page.find(:css, 'div.card-body > ul')
        expect(list_group.text).to have_content '退会したユーザです'
      end
    end
  end
end
