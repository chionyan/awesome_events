require 'rails_helper'

RSpec.describe 'EventsSystem', type: :system do
  before do
    OmniAuth.config.mock_auth[:twitter] = log_in_as user
    visit root_path
  end

  let(:user) { build(:user) }

  it '"イベントを作る"リンクが表示されていること' do
    expect(page).to have_content 'イベントを作る'
  end

  context 'ログイン時' do
    before do
      click_link 'Twitterでログイン'
      visit new_event_path
    end

    it 'イベント作成ページが表示されること' do
      expect(page.current_path).to eq '/events/new'
    end
  end

  context 'ログアウト時' do
    before do
      visit new_event_path
    end

    it 'トップページが表示されること' do
      expect(page.current_path).to eq '/'
    end

    it 'ログインしてくださいと表示されること' do
      expect(page).to have_content 'ログインしてください'
    end
  end
end
