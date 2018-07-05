require 'rails_helper'

RSpec.describe 'Events', type: :request do
  before { OmniAuth.config.mock_auth[:twitter] = log_in_as user }

  describe 'GET #new' do
    subject { get new_event_path }
    let(:user) { build(:user) }

    context 'ログイン時' do
      before do
        get '/auth/twitter/callback'
        subject
      end

      it 'HTTP Status 2xx が返ってくること' do
        expect(response).to be_successful
      end

      it ':newテンプレートを表示すること' do
        expect(response).to render_template :new
      end
    end

    context 'ログアウト時' do
      before do
        get '/logout'
        subject
      end

      it 'HTTP Status 3xx が返ってくること' do
        expect(response).to be_redirect
      end

      it 'トップページにリダイレクトすること' do
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
