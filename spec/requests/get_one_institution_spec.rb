# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Institutions', type: :request do
  describe 'GET /institutions/<id>' do
    before do
      type = create(:institution_type)
      (1..20).each do |_n|
        create(:institution, institution_type: type)
      end
    end

    it 'returns a institution when the id is specified' do
      get "/institutions/#{Institution.first.id}", params: { id: Institution.first.id }
      expect(JSON.parse(response.body)['name']).to eq(Institution.first.name)
    end

    it 'returns an error when institution with the id does not exist' do
      get '/institutions/9999999999'
      expect(response.status).to eq(400)
    end
  end
end
