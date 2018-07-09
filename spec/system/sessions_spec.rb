require 'rails_helper'

RSpec.describe 'SessionsSystem', type: :system do
  before do
    OmniAuth.config.mock_auth[:twitter] = log_in_as user
    visit root_path
  end

  context 'ユーザが未登録の場合' do
    let(:user) { build(:user) }

    context 'ユーザがログインしていない時' do
      it '"Twitterでログイン"リンクが表示されること' do
        expect(page).to have_content 'Twitterでログイン'
      end

      context '"Twitterログイン"をクリックした時' do
        before { click_link 'Twitterでログイン' }

        it 'トップページが表示されること' do
          expect(page.current_path).to eq root_path
        end

        it 'ログインしましたと表示されること' do
          expect(page).to have_content 'ログインしました'
        end
      end
    end

    context 'ユーザがログインしている時' do
      before { click_link 'Twitterでログイン' }

      it '"ログアウト"リンクが表示されること' do
        expect(page).to have_content 'ログアウト'
      end

      context '"ログアウト"をクリックした時' do
        before { click_link 'ログアウト' }

        it 'トップページが表示されること' do
          expect(page.current_path).to eq root_path
        end

        it 'ログアウトしましたと表示されること' do
          expect(page).to have_content 'ログアウトしました'
        end
      end
    end
  end

  context 'ユーザが登録済の場合' do
    let(:user) { create(:user) }

    context 'ユーザがログインしていない時' do
      it '"Twitterでログイン"リンクが表示されること' do
        expect(page).to have_content 'Twitterでログイン'
      end

      context '"Twitterログイン"をクリックした時' do
        before { click_link 'Twitterでログイン' }

        it 'トップページが表示されること' do
          expect(page.current_path).to eq root_path
        end

        it 'ログインしましたと表示されること' do
          expect(page).to have_content 'ログインしました'
        end
      end
    end

    context 'ユーザがログインしている時' do
      before { click_link 'Twitterでログイン' }

      it '"ログアウト"リンクが表示されること' do
        expect(page).to have_content 'ログアウト'
      end

      context '"ログアウト"をクリックした時' do
        before { click_link 'ログアウト' }

        it 'トップページが表示されること' do
          expect(page.current_path).to eq root_path
        end

        it 'ログアウトしましたと表示されること' do
          expect(page).to have_content 'ログアウトしました'
        end
      end
    end
  end
end
