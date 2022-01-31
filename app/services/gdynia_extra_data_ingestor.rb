# frozen_string_literal: true

require 'httparty'

class GdyniaExtraDataIngestor < ApplicationService
  def call
    response = HTTParty.get(
      "#{GDYNIA_API_BASE}/schools/",
      query: { format: 'json' }
    )
    JSON.parse(response.body)
  end
end
