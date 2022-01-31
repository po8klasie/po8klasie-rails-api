# frozen_string_literal: true

require gdynia_api_base
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
