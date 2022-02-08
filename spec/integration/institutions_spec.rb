# frozen_string_literal: tru
require 'swagger_helper'

describe 'Institutions API' do
  path '/institutions' do
    get 'Retrieves all institutions' do
      tags 'Institutions'
      consumes 'application/json'

      parameter name: :page, in: :query, type: :string, default: '1', description: 'Page number'
      parameter name: :page_size, in: :query, type: :string, default: '10', description: 'Page size'

      before do 
        type = create(:institution_type)
        #create 10 institutions with institution_type: type
        create_list(:institution, 10, institution_type: type)
      end

      let(:page) {"2"}
      let(:page_size) {"3"}

      response '200', 'blog found' do
        run_test! do |response|
          expect(JSON.parse(response.body).size).to equal(3)
        end
      end
    end
  end
end
