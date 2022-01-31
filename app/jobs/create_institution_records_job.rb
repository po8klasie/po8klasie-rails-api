# frozen_string_literal: true

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

      batch_insert_institutions = []
      raw_institutions.each_with_object({}) do |raw_institution, institution|
        institution[:institution_type_id] = institution_type.id
        institution[:name] = raw_institution.fetch('nazwa')
        institution[:rspo_institution_type_id] = raw_institution.dig('typ', 'id')
        institution[:rspo_institution_id] = raw_institution.fetch('numerRspo')
        institution[:public] = raw_institution.dig('statusPublicznoPrawny', 'nazwa') == 'publiczna'
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

  def get_raw_institutions(page, institution_type_id)
    response = HTTParty.get(
      "#{RSPO_API_BASE}/placowki/",
      headers: { 'accept' => 'application/json' },
      query: { page: page, typ_podmiotu_id: institution_type_id }
    )
    JSON.parse(response.body)
  end
end
