require 'rails_helper'

RSpec.describe 'EventsSystem', type: :system do
  before do
    OmniAuth.config.mock_auth[:twitter] = log_in_as user
    travel_to '2018-07-07 18:30:00'
    visit root_path
  end

  context 'ユーザがログインしていない時' do
    let(:user) { create(:user) }

    context 'イベント作成ページにアクセスした時' do
      let(:event) { build(:event) }
      before { visit new_event_path }

      it 'トップページにリダイレクトされること' do
        expect(page.current_path).to eq root_path
      end
      it 'ログインしてくださいと表示されること' do
        expect(page).to have_content 'ログインしてください'
      end
    end

    context 'イベント詳細ページにアクセスした時' do
      let!(:event) { create(:event) }
      before { visit event_path(event.id) }

      it 'イベントの詳細が表示されること' do
        expect(page).to have_event_attribute(event)
      end
    end

    context 'イベント一覧ページにアクセスした場合' do
      let!(:event) { create(:event) }
      let!(:past_event) { create(:past_event) }
      let!(:future_event) { create(:future_event) }
      before { visit events_path }

      it '未開催のイベント一覧が表示されること' do
        expect(page).to have_content event.name, future_event.name
        expect(page).to_not have_content past_event.name
      end

      it '開始時間順でイベント一覧が表示されること' do
        list_group_item = page.all('.list-group-item')

        expect(list_group_item[0].find('h4').text).to eq event.name
        expect(list_group_item[1].find('h4').text).to eq future_event.name
      end

      context 'イベント名リンクをクリックした時' do
        before { click_link event.name }

        it 'イベントの詳細ページに遷移すること' do
          expect(page.current_path).to eq event_path(event.id)
        end
      end
    end
  end

  context 'ユーザがログインしている時' do
    before { click_link 'Twitterでログイン' }

    let(:user) { create(:user) }

    context 'イベント作成ページにアクセスした時' do
      before { visit new_event_path }

      context 'フォームに有効なパラメータを入力後、"作成"ボタンをクリックした場合' do
        let(:event) { build(:event) }
        before do
          event_form_as event
          click_button '作成'
        end

        it 'イベント詳細ページにリダイレクトされること' do
          expect(page.current_path).to eq event_path(Event.order(:created_at).last)
        end
        it 'イベントの詳細が表示されること' do
          expect(page).to have_event_attribute(event)
        end
        it '"作成しました"メッセージが表示されること' do
          expect(page).to have_content '作成しました'
        end
      end

      context 'フォームに無効なパラメータを入力後、"作成"ボタンをクリックした場合' do
        let(:event) { build(:event, params) }
        let(:ja_attribute) { I18n.t("activerecord.attributes.event.#{params.keys.first}") }
        let!(:ja_error_messages_blank) { I18n.t('errors.messages.blank') }

        before do
          event_form_as event
          click_button '作成'
        end

        context '名前が空の場合' do
          let(:params) { { name: '' } }

          it '適切なエラーメッセージが表示されること' do
            expect(page).to have_content "#{ja_attribute}#{ja_error_messages_blank}"
          end
        end

        context '場所が空の場合' do
          let(:params) { { place: '' } }

          it '適切なエラーメッセージが表示されること' do
            expect(page).to have_content "#{ja_attribute}#{ja_error_messages_blank}"
          end
        end

        context '内容が空の場合' do
          let(:params) { { content: '' } }

          it '適切なエラーメッセージが表示されること' do
            expect(page).to have_content "#{ja_attribute}#{ja_error_messages_blank}"
          end
        end

        context '開始時間が終了時間以上の場合' do
          let(:params) { { start_time: '2018-07-07 22:00:00' } }

          it '適切なエラーメッセージが表示されること' do
            expect(page).to have_content '開始時間は終了時間よりも前に設定してください'
          end
        end
      end
    end

    context 'イベント詳細ページにアクセスした時' do
      let!(:event) { create(:event) }
      before { visit event_path(event.id) }

      it 'イベントの詳細が表示されること' do
        expect(page).to have_event_attribute(event)
      end
    end

    context 'イベント一覧ページにアクセスした場合' do
      let!(:event) { create(:event) }
      let!(:past_event) { create(:past_event) }
      let!(:future_event) { create(:future_event) }

      before { visit events_path }

      it '未開催のイベント一覧が表示されること' do
        expect(page).to have_content event.name, future_event.name
        expect(page).to_not have_content past_event.name
      end

      it '開始時間順でイベント一覧が表示されること' do
        list_group_item = page.all('.list-group-item')

        expect(list_group_item[0].find('h4').text).to eq event.name
        expect(list_group_item[1].find('h4').text).to eq future_event.name
      end

      context 'イベント名リンクをクリックした時' do
        before { click_link event.name }

        it 'イベントの詳細ページに遷移すること' do
          expect(page.current_path).to eq event_path(event.id)
        end
      end
    end
  end
end
