# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GdyniaExtraDataIngestor', type: :service do
  describe 'when using the call function' do
    it 'returns the raw data from the Gdynia API' do
      raw_data = GdyniaExtraDataIngestor.new.call
      expect(raw_data).to be_a(Array)
      expect(raw_data.size).to be > 0
    end
  end
end
