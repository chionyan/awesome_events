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

  context 'ログアウト時' do
    before { visit root_path }

    it '"Twitterでログイン"リンクが表示されること' do
      expect(page).to have_content 'Twitterでログイン'
    end

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

  context 'ログイン時' do
    before do
      visit root_path
      click_link 'Twitterでログイン'
    end

    it '"ログアウト"リンクが表示されること' do
      expect(page).to have_content 'ログアウト'
    end

    context '"ログアウト"をクリックした時' do
      before { click_link 'ログアウト' }

      it 'トップページに遷移していること' do
        expect(page.current_path).to eq root_path
      end

      it 'ログアウトしましたと表示されること' do
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end
end
