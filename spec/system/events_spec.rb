require 'rails_helper'

RSpec.describe 'EventsSystem', type: :system do
  before do
    OmniAuth.config.mock_auth[:twitter] = log_in_as user
    travel_to event.start_time
    visit root_path
  end

  let(:user) { build(:user) }
  let(:event) { build(:event) }
  let(:event_holding_time) { "#{event.start_time.strftime('%Y/%m/%d %H:%M')} - #{event.end_time.strftime('%Y/%m/%d %H:%M')}" }

  it '"イベントを作る"リンクが表示されていること' do
    expect(page).to have_content 'イベントを作る'
  end

  context 'イベント詳細ページにアクセスした場合' do
    subject { visit event_path(event.id) }
    let(:event) { create(:event) }

    it 'イベント詳細ページが表示されること' do
      subject
      expect(page).to have_content event.name
      expect(page).to have_content event.place
      expect(page).to have_content event.content
      expect(page).to have_content event_holding_time
    end
  end

  context 'ユーザがログインしている場合' do
    before do
      click_link 'Twitterでログイン'
      visit new_event_path
    end

    it 'イベント作成ページが表示されること' do
      expect(page.current_path).to eq '/events/new'
    end

    context 'フォームに有効なパラメータを入力した場合' do
      subject { click_button '作成' }

      before do
        fill_in '名前', with: event.name
        fill_in '場所', with: event.place
        fill_in '内容', with: event.content
        select event.start_time.year.to_s, from: 'event_start_time_1i'
        select event.start_time.month.to_s, from: 'event_start_time_2i'
        select event.start_time.day.to_s, from: 'event_start_time_3i'
        select event.start_time.hour.to_s.rjust(2, '0'), from: 'event_start_time_4i'
        select event.start_time.min.to_s.rjust(2, '0'), from: 'event_start_time_5i'
        select event.end_time.year.to_s, from: 'event_end_time_1i'
        select event.end_time.month.to_s, from: 'event_end_time_2i'
        select event.end_time.day.to_s, from: 'event_end_time_3i'
        select event.end_time.hour.to_s.rjust(2, '0'), from: 'event_end_time_4i'
        select event.end_time.min.to_s.rjust(2, '0'), from: 'event_end_time_5i'
      end

      it 'イベント詳細ページが表示されること' do
        subject
        expect(page).to have_content event.name
        expect(page).to have_content event.place
        expect(page).to have_content event.content
        expect(page).to have_content event_holding_time
      end

      it '"作成しました"メッセージが表示されること' do
        subject
        expect(page).to have_content '作成しました'
      end
    end

    context 'フォームに無効なパラメータを入力した場合' do
      subject { click_button '作成' }

      context '名前が空の場合' do
        before { fill_in 'event_name', with: '' }

        it '"名前を入力してください"メッセージが表示されること' do
          subject
          expect(page).to have_content '名前を入力してください'
        end
      end

      context '場所が空の場合' do
        before { fill_in 'event_place', with: '' }

        it '"場所を入力してください"メッセージが表示されること' do
          subject
          expect(page).to have_content '場所を入力してください'
        end
      end

      context '内容が空の場合' do
        before { fill_in 'event_place', with: '' }

        it '"内容を入力してください"メッセージが表示されること' do
          subject
          expect(page).to have_content '内容を入力してください'
        end
      end

      context '開始時間が終了時間以上の場合' do
        before do
          select event.end_time.year.to_s, from: 'event_start_time_1i'
          select event.end_time.month.to_s, from: 'event_start_time_2i'
          select event.end_time.day.to_s, from: 'event_start_time_3i'
          select event.end_time.hour.to_s.rjust(2, '0'), from: 'event_start_time_4i'
          select event.end_time.min.to_s.rjust(2, '0'), from: 'event_start_time_5i'
        end

        it '"開始時間は終了時間よりも前に設定してください"メッセージが表示されること' do
          subject
          expect(page).to have_content '開始時間は終了時間よりも前に設定してください'
        end
      end
    end
  end

  context 'ユーザがログインしていない場合' do
    before { visit new_event_path }

    it 'トップページが表示されること' do
      expect(page.current_path).to eq '/'
    end

    it 'ログインしてくださいと表示されること' do
      expect(page).to have_content 'ログインしてください'
    end
  end
end
