require 'rails_helper'

RSpec.describe 'EventsSystem', type: :system do
  include_context 'with_log_in'

  before { travel_to '2018-07-07 18:30:00' }

  describe 'イベント作成ページ' do
    before { click_link 'イベントを作る' }

    it 'イベント作成ページに遷移すること' do
      expect(page.current_path).to eq '/events/new'
    end

    context '無効な値を入力後、"作成"ボタンをクリックした場合' do
      before do
        fill_in 'event_name', with: ''
        fill_in 'event_place', with: ''
        fill_in 'event_content', with: ''
        click_button '作成'
      end

      it '適切なエラーメッセージが表示されること' do
        ja_name = I18n.t('activerecord.attributes.event.name')
        ja_place = I18n.t('activerecord.attributes.event.place')
        ja_content = I18n.t('activerecord.attributes.event.content')
        ja_error_messages_blank = I18n.t('errors.messages.blank')

        expect(page).to have_content "#{ja_name}#{ja_error_messages_blank}"
        expect(page).to have_content "#{ja_place}#{ja_error_messages_blank}"
        expect(page).to have_content "#{ja_content}#{ja_error_messages_blank}"
        expect(page).to have_content '開始時間は終了時間よりも前に設定してください'
      end
    end

    context '有効な値を入力後、"作成"ボタンをクリックした場合' do
      let!(:event) { build(:event) }

      before do
        fill_in 'event_name', with: event.name
        fill_in 'event_place', with: event.place
        fill_in 'event_content', with: event.content
        select_datetime 'event_start_time', event.start_time
        select_datetime 'event_end_time', event.end_time
        click_button '作成'
      end

      it '作成されたイベントの詳細ページに遷移すること' do
        last_event = Event.order(:created_at).last

        expect(page.current_path).to eq "/events/#{last_event.id}"
        expect(page).to have_content last_event.name
        expect(page).to have_content last_event.place
        expect(page).to have_content last_event.content
        expect(page).to have_content "#{last_event.start_time.strftime('%Y/%m/%d %H:%M')} - #{last_event.end_time.strftime('%Y/%m/%d %H:%M')}"
      end

      it '"作成しました" メッセージが表示されていること' do
        expect(page).to have_content '作成しました'
      end

      it '"イベントを編集する" ボタンが表示されていること' do
        expect(page).to have_content 'イベントを編集する'
      end
    end
  end

  describe 'イベント編集ページ' do
    let!(:event) { create(:event, owner: user) }

    before do
      click_link 'AwesomeEvents'
      click_link event.name
      click_link 'イベントを編集する'
    end

    it 'イベント編集ページに遷移すること' do
      expect(page.current_path).to eq "/events/#{event.id}/edit"
    end

    describe '名前を編集後、"更新"ボタンをクリックした時' do
      before do
        fill_in 'event_name', with: "#{event.name}_edit"
        click_button '更新'
      end

      it '更新されたイベントの詳細ページに遷移すること' do
        expect(page.current_path).to eq "/events/#{event.id}"
        expect(page).to have_content "#{event.name}_edit"
      end

      it '"更新しました"メッセージが表示されていること' do
        expect(page).to have_content '更新しました'
      end
    end
  end

  describe '未ログイン時のイベント一覧ページ' do
    let!(:event) { create(:event, owner: user) }
    let!(:past_event) { create(:past_event) }
    let!(:future_event) { create(:future_event) }

    before { click_link 'ログアウト' }

    it '開始時間順に未開催のイベント一覧が表示されること' do
      list_group_item = page.all('.list-group-item')

      expect(list_group_item[0].find('h4').text).to eq event.name
      expect(list_group_item[1].find('h4').text).to eq future_event.name
      expect(page).to_not have_content past_event.name
    end

    describe 'イベント名のリンクをクリックした時' do
      before { click_link event.name }

      it 'イベントの詳細ページに遷移すること' do
        expect(page.current_path).to eq "/events/#{event.id}"
        expect(page).to have_content event.name
        expect(page).to have_content event.place
        expect(page).to have_content event.content
        expect(page).to have_content "#{event.start_time.strftime('%Y/%m/%d %H:%M')} - #{event.end_time.strftime('%Y/%m/%d %H:%M')}"
      end

      it '"イベントを編集する"リンクが表示されないこと' do
        expect(page).to_not have_content 'イベントを編集する'
      end
    end
  end
end
