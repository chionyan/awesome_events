require 'rails_helper'

RSpec.describe 'RetireSystem', type: :system do
  let!(:user) { create(:user) }
  let!(:event) { create(:event, owner: user) }

  before do
    travel_to '2018-07-07 18:30:00'
    OmniAuth.config.mock_auth[:twitter] = log_in_as user
    visit '/'
    click_link 'Twitterでログイン'
    click_link 'AwesomeEvents'
  end

  it '"退会"ボタンが表示されること' do
    expect(page).to have_content '退会'
  end
end
