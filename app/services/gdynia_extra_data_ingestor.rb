# frozen_string_literal: true

require 'httparty'

class GdyniaExtraDataIngestor < ApplicationService
  def call
    response = HTTParty.get(
      "#{GDYNIA_API_BASE}/schools/",
      query: { format: 'json' }
    )
    raw_data = JSON.parse(response.body)
    #     The Gdynia api provides records in a idiotic format where insted of giving us and array of
    #     hashes it gives us a hash of hashes with the numerical id of the school as the second key.
    #     for example
    #     {
    #       "1" => {
    #         some data
    #       }
    #       "2" => {
    #         some data
    #       }
    #       ....
    #       "60" => {
    #         some data
    #       }
    #     }
    #     Example response has to contain 60 records
    index = 1
    transformed_data = []
    loop do
      raw_record = raw_data.fetch(index.to_s, nil)
      break if raw_record.nil?

      # We are intersted in the following fields: "w51", "wx2", "wx3", "w68", "w88"
      transformed_record = {
        'rspo' => raw_record.fetch('rspo'),
        'w51' => raw_record.fetch('w51'),
        'wx2' => raw_record.fetch('wx2'),
        'wx3' => raw_record.fetch('wx3'),
        'w68' => raw_record.fetch('w68'),
        'w88' => raw_record.fetch('w88')
      }
      transformed_data << transformed_record

      index += 1
    end

    transformed_data
  end
end
