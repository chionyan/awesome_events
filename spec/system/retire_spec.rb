require 'rails_helper'

RSpec.describe 'RetireSystem', type: :system do
  let!(:user) { create(:user) }
  let!(:event) { create(:event, owner: user) }

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
    before do
      click_link '退会'
      click_link '退会する'
    end

    it 'トップページに遷移すること' do
      expect(page.current_path).to eq '/'
    end

    it '"退会完了しました" メッセージが表示されていること' do
      expect(page).to have_content '退会完了しました'
    end
  end
end
