require 'rails_helper'

RSpec.describe 'SessionsRequest', type: :request do
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

      it 'HTTP Status 3xx が返ってくること' do
        subject
        expect(response).to be_redirect
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

      it 'HTTP Status 3xx が返ってくること' do
        subject
        expect(response).to be_redirect
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

    it 'HTTP Status 3xx が返ってくること' do
      subject
      expect(response).to be_redirect
    end
  end
end
