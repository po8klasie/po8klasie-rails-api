# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Institutions', type: :request do
  describe 'GET /institutions/get_all_institutions' do
    before do
      type = create(:institution_type)
      (1..60).each do |_n|
        create(:institution, institution_type: type)
      end
    end

    it 'returns 10 institutions when no pagination_length is specified' do
      get '/institutions/get_all_institutions'
      expect(JSON.parse(response.body).size).to equal(10)
    end

    it 'returns the correct number of institutions when pagination_length is specified' do
      (1..20).each do |pagination_length|
        get '/institutions/get_all_institutions', params: { pagination_length: pagination_length }
        expect(JSON.parse(response.body).size).to equal(pagination_length)
      end
    end

    it "doesn't allow negative pagination_length" do
      get '/institutions/get_all_institutions', params: { pagination_length: '-1' }
      expect(response.status).to eq(400)
    end

    it "doesn't allow 0 as pagination_length" do
      get '/institutions/get_all_institutions', params: { pagination_length: '0' }
      expect(response.status).to eq(400)
    end

    it "returns empty array when there aren't enough institutions" do
      get '/institutions/get_all_institutions', params: { page: '9999999999' }
      expect(JSON.parse(response.body).size).to equal(0)
    end
  end
end
