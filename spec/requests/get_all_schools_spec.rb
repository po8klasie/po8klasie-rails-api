# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Schools', type: :request do
  describe 'GET /schools/get_all_schools' do
    before do
      (1..60).each do |n|
        School.new(name: "School #{n}").save
      end
    end

    it 'returns 10 schools when no pagination_length is specified' do
      get '/schools/get_all_schools'
      expect(JSON.parse(response.body).size).to equal(10)
    end

    it 'returns the correct number of schools when pagination_length is specified' do
      (1..20).each do |pagination_length|
        get '/schools/get_all_schools', params: { pagination_length: pagination_length }
        expect(JSON.parse(response.body).size).to equal(pagination_length)
      end
    end

    it "doesn't allow negative pagination_length" do
      get '/schools/get_all_schools', params: { pagination_length: '-1' }
      expect(response.status).to eq(400)
    end

    it "doesn't allow 0 as pagination_length" do
      get '/schools/get_all_schools', params: { pagination_length: '0' }
      expect(response.status).to eq(400)
    end

    it "returns empty array when there aren't enough schools" do
      get '/schools/get_all_schools', params: { page: '9999999999' }
      expect(JSON.parse(response.body).size).to equal(0)
    end
  end
end
