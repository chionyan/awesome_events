require 'rails_helper'

RSpec.describe 'SessionsSystem', type: :system do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      provider: user.provider,
      uid: user.uid,
      info: {
        nickname: user.nickname,
        image: user.image_url,
      },
    )
  end

  let(:user) { build(:user) }

  context '"Twitterログイン"をクリックした時' do
    before do
      visit root_path
      click_link 'Twitterでログイン'
    end

    it 'トップページに遷移していること' do
      expect(page.current_path).to eq root_path
    end

    it 'ログインしましたと表示されること' do
      expect(page).to have_content 'ログインしました'
    end
  end
end
