# frozen_string_literal: true

# this file is entirely related to rswag which is on hold for now
#rubocop:disable all
=begin
require 'swagger_helper'

describe 'Institutions API' do
  path '/institutions' do
    get 'Retrieves all institutions' do
      tags 'Institutions'
      consumes 'application/json'

      parameter name: :page, in: :query, type: :string, default: '1', description: 'Page number'
      parameter name: :page_size, in: :query, type: :string, default: '10', description: 'Page size'

      response '200', 'blog found' do
        run_test! do |response|
          expect(JSON.parse(response.body).size).to equal(10)
        end
      end
    end
  end
end
=end
#rubocop:enable all
