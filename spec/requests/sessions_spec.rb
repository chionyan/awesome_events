require 'rails_helper'

RSpec.describe 'SessionsRequest', type: :request do
  before { OmniAuth.config.mock_auth[:twitter] = log_in_as user }

  describe 'GET #create' do
    # get '/auth/twitter' の後にコールバックが実行されないため、直接コールバックURLを GET する
    subject { get '/auth/twitter/callback' }

    context 'ユーザが未登録の場合' do
      let(:user) { build(:user) }

      it 'ユーザを新規作成すること' do
        expect { subject }.to change(User, :count).by(1)
      end

      it 'session に user_id が保存されていること' do
        subject
        expect(session[:user_id]).to be_present
      end

      it 'トップページにリダイレクトすること' do
        subject
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ユーザが登録済の場合' do
      let!(:user) { create(:user) }

      it 'ユーザが作成されないこと' do
        expect { subject }.not_to change(User, :count)
      end

      it 'session に user_id が保存されていること' do
        subject
        expect(session[:user_id]).to be_present
      end

      it 'トップページにリダイレクトすること' do
        subject
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #destroy' do
    subject { get '/logout' }
    let!(:user) { build(:user) }

    it 'session の user_id が nil になっているいること' do
      subject
      expect(session[:user_id]).to be_nil
    end

    it 'トップページにリダイレクトすること' do
      subject
      expect(response).to redirect_to(root_path)
    end
  end
end
