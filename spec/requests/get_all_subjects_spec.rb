# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Subejcts', type: :request do
  describe 'GET /subjects' do
    before do
      create(:subject, name: 'Math')
      create(:subject, name: 'English')
    end

    it 'returns all subjects' do
      get '/subjects'
      expect(JSON.parse(response.body)["subjects"].size).to eq(2)
      expect(JSON.parse(response.body)["subjects"][0]['name']).to eq('Math')
      expect(JSON.parse(response.body)["subjects"][1]['name']).to eq('English')
    end
  end
end
