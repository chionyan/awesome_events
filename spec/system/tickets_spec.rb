require 'rails_helper'

RSpec.describe 'TicketsSystem', type: :system do
  let!(:user) { create(:user) }
  let!(:event) { create(:event, owner: user) }

  before do
    travel_to '2018-07-07 18:30:00'
    OmniAuth.config.mock_auth[:twitter] = log_in_as user
    visit '/'
    click_link 'Twitterでログイン'
  end

  context 'ログイン済かつイベントに参加していない場合' do
    before do
      click_link 'AwesomeEvents'
      click_link event.name
    end

    it '"参加する"ボタンが表示されること' do
      expect(page).to have_content '参加する'
    end

    describe 'イベント参加アクション' do
      before do
        click_button '参加する'
        sleep 0.5
      end

      it 'イベント参加フォームが表示されること' do
        expect(page).to have_content '参加コメント'
      end

      context '"送信"ボタンをクリックした場合' do
        subject do
          click_button '送信'
          sleep 0.5
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
          sleep 0.5
        end

        it 'イベント参加フォームが消えること' do
          subject
          expect(page).to_not have_content '参加コメント'
        end
      end
    end
  end

  context 'イベント参加済みの場合' do
    let!(:ticket) { create(:ticket, user: user, event: event) }

    before do
      click_link 'AwesomeEvents'
      click_link event.name
    end

    it '"参加登録済み"ボタンが表示されること' do
      expect(page).to have_content '参加登録済み'
    end
  end

  context '未ログイン時の場合' do
    before do
      click_link 'ログアウト'
      click_link 'AwesomeEvents'
      click_link event.name
    end

    it '"参加するにはログインしてください"ボタンが表示されること' do
      expect(page).to have_content '参加するにはログインしてください'
    end
  end

  context '参加者一覧表示機能' do
    let!(:user_2) { create(:user, :user_2) }
    let!(:ticket) { create(:ticket, user: user, event: event) }
    let!(:ticket_2) { create(:ticket, :ticket_2, user: user_2, event: event) }

    before do
      click_link 'AwesomeEvents'
      click_link event.name
    end

    it '参加順に参加者一覧が表示されること' do
      list_group_item = page.all(:css, 'div.card-body > ul > li')

      expect(list_group_item[0].text).to include user.nickname
      expect(list_group_item[0].text).to include ticket.comment
      expect(list_group_item[1].text).to include user_2.nickname
      expect(list_group_item[1].text).to include ticket_2.comment
    end
  end
end
