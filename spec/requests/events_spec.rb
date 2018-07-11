require 'rails_helper'

RSpec.describe 'Events', type: :request do
  before { OmniAuth.config.mock_auth[:twitter] = log_in_as user }

  describe 'GET #new' do
    subject { get new_event_path }

    let(:user) { create(:user) }

    context 'ユーザがログインしている場合' do
      before { get '/auth/twitter/callback' }

      it 'HTTP Status 2xx が返ってくること' do
        subject
        expect(response).to be_successful
      end

      it ':newテンプレートを表示すること' do
        subject
        expect(response).to render_template :new
      end
    end

    context 'ユーザがログインしていない場合' do
      it 'HTTP Status 3xx が返ってくること' do
        subject
        expect(response).to be_redirect
      end

      it 'トップページにリダイレクトすること' do
        subject
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    subject { post events_path, params: params }

    let(:user) { create(:user) }
    let(:event) { build(:event, owner: user) }

    before { get '/auth/twitter/callback' }

    context 'params が有効なパラメータの場合' do
      let(:params) { { event: attributes_for(:event) } }

      it 'HTTP Status 3xx が返ってくること' do
        subject
        expect(response).to be_redirect
      end

      it 'イベントを新規作成すること' do
        expect { subject }.to change(Event, :count).by(1)
      end

      it ':show にリダイレクトすること' do
        subject
        expect(response).to redirect_to(Event.order(:created_at).last)
      end
    end

    context 'params が無効なパラメータの場合' do
      let(:params) { { event: attributes_for(:event, name: nil) } }

      it 'HTTP Status 2xx が返ってくること' do
        subject
        expect(response).to be_successful
      end

      it 'イベントが作成されないこと' do
        expect { subject }.not_to change(Event, :count)
      end

      it ':newテンプレートを再表示すること' do
        subject
        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    subject { get event_path(event.id) }

    let(:user) { create(:user) }
    let(:event) { create(:event, owner: user) }

    it 'HTTP Status 2xx が返ってくること' do
      subject
      expect(response).to be_successful
    end

    it ':showテンプレートを表示すること' do
      subject
      expect(response).to render_template :show
    end
  end

  describe 'GET #index' do
    subject { get events_path }

    let(:user) { create(:user) }
    let(:event) { create(:event, owner: user) }

    it 'HTTP Status 2xx が返ってくること' do
      subject
      expect(response).to be_successful
    end

    it ':indexテンプレートを表示すること' do
      subject
      expect(response).to render_template :index
    end
  end
end
