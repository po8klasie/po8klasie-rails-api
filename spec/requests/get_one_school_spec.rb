# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Schools', type: :request do
  describe 'GET /schools/get_one_school' do
    before(:each) do
      (1..60).each do |n|
        School.new(name: "School #{n}").save
      end
    end

    it 'returns a school when the id is specified' do
      get '/schools/get_one_school', params: { id: School.first.id }
      expect(JSON.parse(response.body)['name']).to eq('School 1')
    end

    it 'returns an error when no id is specified' do
      get '/schools/get_one_school'
      expect(response.status).to eq(400)
    end

    it 'returns an error when school with the id does not exist' do
      get '/schools/get_one_school', params: { id: '9999999999' }
      expect(response.status).to eq(400)
    end
  end
end
