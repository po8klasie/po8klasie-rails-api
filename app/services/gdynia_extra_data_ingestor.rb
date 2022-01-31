# frozen_string_literal: true

require httparty

class GdyniaExtraDataIngestor < ApplicationService
  def call
    response = HTTParty.get(
      "#{GdyniaApiBase}/schools/",
      query: { format: 'json' }
    )
    JSON.parse(response.body)
  end
end
