# frozen_string_literal: true

require 'httparty'

class GdyniaExtraDataClient
  def raw_schools
    response = HTTParty.get(
      "#{GDYNIA_API_BASE}/schools/",
      query: { format: 'json' },
      timeout: 10
    )
    raw_data = JSON.parse(response.body)

    raw_data.map do |raw_record|
      # We are intersted in the following fields: "w51", "wx2", "wx3", "w68", "w88",
      # "opis_szkoły",  "sport", "jezyki_obce", "profile_klas", "zajecia_dodatkowe"
      {
        'rspo' => raw_record.fetch('rspo').to_i,
        'w51' => raw_record.fetch('w51').to_i,
        'wx2' => raw_record.fetch('wx2').to_i,
        'wx3' => raw_record.fetch('wx3').to_i,
        'w68' => raw_record.fetch('w68').to_f,
        'w88' => raw_record.fetch('w88').to_f,
        'opis_szkoly' => raw_record.fetch('opis_szkoly'),
        'sport' => raw_record.fetch('sport'),
        'jezyki_obce' => raw_record.fetch('jezyki_obce'),
        'profile_klas' => raw_record.fetch('profile_klas'),
        'zajecia_dodatkowe' => raw_record.fetch('zajecia_dodatkowe')
      }
    end
  end
end
