require 'rails_helper'

RSpec.describe 'WelcomeSystem', type: :system do
  it '' do
    visit '/'
    expect(page).to have_content 'Welcome#index'
  end
end
