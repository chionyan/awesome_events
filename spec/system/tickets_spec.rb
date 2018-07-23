require 'rails_helper'

RSpec.describe 'TicketsSystem', type: :system do
  include_context 'with_log_in'
  include_context 'with_event_create'
  include_context 'with_before_event_start_time'

  before do
    click_link 'AwesomeEvents'
    click_link event.name
  end

  describe 'イベント参加アクション' do
    before do
      click_button '参加する'
      sleep 0.3
    end

    it 'イベント参加フォームが表示されること' do
      expect(page).to have_content '参加コメント'
    end

    context '"送信"ボタンをクリックした場合' do
      subject do
        click_button '送信'
        sleep 0.3
      end

      context '有効な値を入力した場合' do
        before { fill_in 'ticket[comment]', with: 'a' * 30 }

        it '"このイベントに参加表明しました" メッセージが表示がされていること' do
          subject
          expect(page).to have_content 'このイベントに参加表明しました'
        end
      end

      context '無効な値を入力した場合' do
        before { fill_in 'ticket[comment]', with: 'a' * 31 }

        it '適切なエラーメッセージが表示されること' do
          subject
          expect(page).to have_content I18n.t('errors.messages.too_long', count: 30)
        end
      end
    end

    context '"キャンセル"ボタンをクリックした場合' do
      subject do
        click_button 'キャンセル'
        sleep 0.3
      end

      it 'イベント参加フォームが消えること' do
        subject
        expect(page).to_not have_content '参加コメント'
      end
    end
  end
end
