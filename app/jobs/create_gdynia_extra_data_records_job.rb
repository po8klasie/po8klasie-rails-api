# frozen_string_literal: true

class CreateGdyniaExtraDataRecordsJob < ApplicationJob
  queue_as :default

  def perform
    # getting the raw data from the Gdynia API
    raw_data = GdyniaExtraDataIngestor.new.call
    # mapping the raw data to the database
    GdyniaExtraDataMapper.new.call(raw_data)
  end
end
