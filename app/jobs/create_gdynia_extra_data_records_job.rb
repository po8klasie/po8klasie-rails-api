# frozen_string_literal: true

class CreateGdyniaExtraDataRecordsJob < ApplicationJob
  queue_as :default

  def perform
    # getting the raw data from the Gdynia API
    raw_data = GdyniaExtraDataClient.new.raw_schools
    # mapping the raw data to the database
    GdyniaExtraDataMapper.new.call(raw_data)
  end
end
