# frozen_string_literal: true

require 'httparty'

class CreateInstitutionRecordsJob < ApplicationJob
  queue_as :default

  def perform(institution_type_id)
    page = 1
    institution_type = InstitutionType.find_by(rspo_institution_type_id: institution_type_id)
    loop do
      # the records are sent in pages of 100
      raw_institutions = get_raw_institutions(page, institution_type_id)
      break if raw_institutions == []

      page += 1

      batch_insert_institutions = raw_institutions.map do |raw_institution|
        {
          institution_type_id: institution_type.id,
          name: raw_institution.fetch('nazwa'),
          rspo_institution_type_id: raw_institution.dig('typ', 'id'),
          rspo_institution_id: raw_institution.fetch('numerRspo'),
          public: raw_institution.dig('statusPublicznoPrawny', 'nazwa') == 'publiczna',
          latitude: raw_institution.dig('geolokalizacja', 'latitude').to_f,
          longitude: raw_institution.dig('geolokalizacja', 'longitude').to_f,
          website: raw_institution.fetch('stronaInternetowa'),
          email: raw_institution.fetch('email'),
          street: raw_institution.fetch('adresDoKorespondecjiUlica'),
          building_no: raw_institution.fetch('adresDoKorespondecjiNumerBudynku'),
          apartment_no: raw_institution.fetch('adresDoKorespondecjiNumerLokalu'),
          zip_code: raw_institution.fetch('adresDoKorespondecjiKodPocztowy'),
          county: raw_institution.fetch('powiat'),
          municipality: raw_institution.fetch('gmina'),
          town: raw_institution.fetch('miejscowosc')
        }
      end
      # rubocop:disable Rails/SkipsModelValidations
      Institution.insert_all(batch_insert_institutions)
      # rubocop:enable Rails/SkipsModelValidations
    end
  end

  def get_raw_institutions(page, institution_type_id)
    response = HTTParty.get(
      "#{RSPO_API_BASE}/placowki/",
      headers: { 'accept' => 'application/json' },
      query: { page: page, typ_podmiotu_id: institution_type_id }
    )
    JSON.parse(response.body)
  end
end
