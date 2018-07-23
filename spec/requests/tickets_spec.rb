require 'rails_helper'

RSpec.describe 'Tickets', type: :request do
  let(:user) { create(:user) }
  let(:event) { create(:event, owner: user) }

  before { OmniAuth.config.mock_auth[:twitter] = log_in_as user }

  describe 'POST #create' do
    subject { post event_tickets_path(event), params: params }

    let(:ticket) { build(:ticket, user: user, event: event) }

    before { get '/auth/twitter/callback' }

    context 'params が有効なパラメータの場合' do
      let(:params) { { ticket: attributes_for(:ticket, comment: '_' * 30) } }

      it 'HTTP Status 201 が返ってくること' do
        subject
        expect(response.status).to eq 201
      end

      it 'チケットを新規作成すること' do
        expect { subject }.to change(Ticket, :count).by(1)
      end
    end

    context 'params が無効なパラメータの場合' do
      let(:params) { { ticket: attributes_for(:ticket, comment: '_' * 31) } }

      it 'HTTP Status 422 が返ってくること' do
        subject
        expect(response.status).to eq 422
      end

      it 'チケットが作成されないこと' do
        expect { subject }.not_to change(Ticket, :count)
      end

      it '適切なエラーメッセージを返すこと' do
        ja_name = I18n.t('activerecord.attributes.ticket.comment')
        ja_error_messages_too_long = I18n.t('errors.messages.too_long', count: 30)

        subject
        json = JSON.parse(response.body)
        expect(json['messages']).to include "#{ja_name}#{ja_error_messages_too_long}"
      end
    end
  end
end
