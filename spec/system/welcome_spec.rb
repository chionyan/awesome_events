require 'rails_helper'

RSpec.describe 'WelcomeSystem', type: :system do
  context 'イベント詳細ページにアクセスした時' do
    before { visit root_path }

    it '"イベントを作る"リンクが表示されていること' do
      expect(page).to have_content 'イベントを作る'
    end
  end
end
