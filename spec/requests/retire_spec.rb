require 'rails_helper'

RSpec.describe 'RetireRequest', type: :request do
  let(:user) { create(:user) }
  let(:event) { create(:event, owner: user) }

  before { OmniAuth.config.mock_auth[:twitter] = log_in_as user }

  describe 'DELETE #destroy' do
    subject { delete "/users/#{user.id}" }

    before { get '/auth/twitter/callback' }

    it 'HTTP Status 3xx が返ってくること' do
      subject
      expect(response).to be_redirect
    end

    it 'ユーザを削除すること' do
      expect { subject }.to change(User, :count).by(-1)
    end

    it 'セッションを削除すること' do
      subject
      expect(session[:user_id]).to be_nil
    end

    it 'トップページにリダイレクトすること' do
      subject
      expect(response).to redirect_to(root_path)
    end
  end
end
