# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Institutions', type: :request do
  describe 'GET /institutions/index' do
    before do
      type = create(:institution_type)
      (1..25).each do |_n|
        create(:institution, institution_type: type)
      end
    end

    it 'returns 10 institutions when no page_size is specified' do
      get '/institutions'
      expect(JSON.parse(response.body).size).to equal(10)
    end

    it 'returns the correct number of institutions when page_size is specified' do
      (1..20).each do |page_size|
        get '/institutions', params: { page_size: page_size }
        expect(JSON.parse(response.body).size).to equal(page_size)
      end
    end

    it "doesn't allow negative page_size" do
      get '/institutions', params: { page_size: -1 }
      expect(response.status).to eq(422)
    end

    it "doesn't allow 0 as page_size" do
      get '/institutions', params: { page_size: 0 }
      expect(response.status).to eq(422)
    end

    it "returns empty array when there aren't enough institutions" do
      get '/institutions', params: { page: 9_999_999_999 }
      expect(JSON.parse(response.body).size).to equal(0)
    end
  end
end
