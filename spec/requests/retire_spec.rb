require 'rails_helper'

RSpec.describe 'RetireRequest', type: :request do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user, :user_2) }

  before do
    OmniAuth.config.mock_auth[:twitter] = log_in_as user
    allow(Time.zone).to receive(:now).and_return('2018-07-07 11:30:00'.to_datetime)
  end

  describe 'DELETE #destroy' do
    subject { delete "/users/#{user.id}" }

    before { get '/auth/twitter/callback' }

    context '公開中の未終了イベントも未終了の参加イベントもない場合' do
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

    context '公開中の未終了イベントがある場合' do
      let!(:future_event) { create(:event, :future_event, owner: user) }

      it 'ユーザを削除しないこと' do
        expect { subject }.to_not change(User, :count)
      end
    end

    context '未終了の参加イベントがある場合' do
      let!(:future_event) { create(:event, :future_event, owner: other_user) }
      let!(:ticket) { create(:ticket, user: user, event: future_event) }

      it 'ユーザを削除しないこと' do
        expect { subject }.to_not change(User, :count)
      end
    end
  end
end
