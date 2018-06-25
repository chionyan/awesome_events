require 'rails_helper'

RSpec.describe 'WelcomeRequest', type: :request do
  describe 'GET #root' do
    it 'HTTP Status 2xx が返ってくること' do
      get root_path
      expect(response).to be_successful
    end
  end
end
