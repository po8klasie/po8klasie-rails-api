# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Institutions', type: :request do
  describe 'GET /institutions/get_one_institution' do
    before do
      type = create(:institution_type)
      create_list(:institution, 60, institution_type: type)
    end

    it 'returns a institution when the id is specified' do
      get '/institutions/get_one_institution', params: { id: Institution.first.id }
      expect(JSON.parse(response.body)['name']).to eq(Institution.first.name)
    end

    it 'returns an error when no id is specified' do
      get '/institutions/get_one_institution'
      expect(response.status).to eq(400)
    end

    it 'returns an error when institution with the id does not exist' do
      get '/institutions/get_one_institution', params: { id: '9999999999' }
      expect(response.status).to eq(400)
    end
  end
end
