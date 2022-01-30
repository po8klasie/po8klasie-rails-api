# frozen_string_literal: true

require 'httparty'
require 'rspo_api_base'

class CreateInstitutionRecordsJob < ApplicationJob
  queue_as :default

  def perform(institution_type_id)
    page = 1
    loop do
      response = HTTParty.get(
        "#{RspoApiBase}/placowki/",
        headers: { 'accept' => 'application/json' },
        query: { page: page, typ_podmiotu_id: institution_type_id }
      )

      raw_institutions = JSON.parse(response.body)

      # the records are sent in pages of 100
      break if raw_institutions == []
      page += 1

      batch_insert_institutions = []
      raw_institutions.each_with_object({}) do |raw_institution, institution|
        institution[:institution_type_id] = raw_institution.dig('typ', 'id')
        institution[:name] = raw_institution.fetch('nazwa')
        institution[:rspo_institution_id] = raw_institution.fetch('numerRspo')
        if raw_institution.dig('statusPublicznoPrawny', 'nazwa') == 'publiczna'
          institution[:public] = true 
        else 
          institution[:public] = false 
        end
        institution[:latitude] = raw_institution.dig('geolokalizacja', 'latitude').to_f
        institution[:longitude] = raw_institution.dig('geolokalizacja', 'longitude').to_f
        institution[:website] = raw_institution.fetch('stronaInternetowa')
        institution[:email] = raw_institution.fetch('email')
        institution[:city] = raw_institution.fetch('adresDoKorespondecjiMiejscowosc')
        institution[:street] = raw_institution.fetch('adresDoKorespondecjiUlica')
        institution[:building_no] = raw_institution.fetch('adresDoKorespondecjiNumerBudynku')
        institution[:apartment_no] = raw_institution.fetch('adresDoKorespondecjiNumerLokalu')
        institution[:zip_code] = raw_institution.fetch('adresDoKorespondecjiKodPocztowy')

        batch_insert_institutions << institution
      end

      # rubocop:disable Rails/SkipsModelValidations
      Institution.insert_all(batch_insert_institutions)
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
