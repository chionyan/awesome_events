require 'rails_helper'

RSpec.describe 'SessionsRequest', type: :request do
  # get '/auth/twitter' の後にコールバックが実行されないため、直接コールバックURLを GET する
  subject { get '/auth/twitter/callback' }

  describe 'GET /auth/twitter/callback' do
    context 'ユーザが未登録の場合' do
      it 'ユーザを新規作成すること' do
        expect { subject }.to change(User, :count).by(1)
      end
    end

    context 'ユーザが登録済の場合' do
      before { create(:user) }

      it 'ユーザが作成されないこと' do
        expect { subject }.to change(User, :count).by(0)
      end
    end

    it 'session に user_id が保存されていること' do
      subject
      expect(session[:user_id]).to be_present
    end

    it 'HTTP Status 3xx が返ってくること' do
      subject
      expect(response).to be_redirect
    end
  end
end
