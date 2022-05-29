# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CreateSubjectsService', type: :service do
  describe '#call' do
    it 'creates all the required subjects in the database' do
        CreateSubjectsService.new.call
        #expect subject count to be greater than 0
        expect(Subject.count).to be > 0
    end
  end
end
