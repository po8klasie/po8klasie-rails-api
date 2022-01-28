# frozen_string_literal: true

require 'net/http'

class CreateInstitutionRecordsJob < ApplicationJob
  queue_as :default

  def perform(institution_type_id)

    i = 1 
    while true
      rspo_api_uri = URI("http://194.54.26.132/api/placowki/?page=#{i}&typ_podmiotu_id=#{institution_type_id}")
      request = Net::HTTP::Get.new(rspo_api_uri)
      request['accept'] = 'application/json' 
      response = Net::HTTP.start(rspo_api_uri.hostname, rspo_api_uri.port) do |http|
        http.request(request)
      end

      raw_institutions = JSON.parse(response.body)

      # the records are sent in pages of 100
      if raw_institutions == []
        break 
      end
      i += 1

      batch_insert_institutions = []
      raw_institutions.each do |raw_institution|
        institution = {}
        institution["institution_type_id"] = raw_institution['typ']['id']
        institution["name"] = raw_institution['nazwa']
        institution["rspo_institution_id"] = raw_institution['numerRspo']
        if raw_institution['statusPublicznoPrawny']['nazwa'] == 'publiczna'
          institution["public"] = true 
        else  
          institution["public"] = false 
        end
        institution["latitude"] = raw_institution['geolokalizacja']['latitude'].to_f
        institution["longitude"] = raw_institution['geolokalizacja']['longitude'].to_f
        institution["website"] = raw_institution['stronaInternetowa']
        institution["email"] = raw_institution['email']
        # rubocop:disable Layout/LineLength
        institution["address"] = "#{raw_institution['adresDoKorespondecjiMiejscowosc']} #{raw_institution['adresDoKorespondecjiUlica']} #{raw_institution['adresDoKorespondecjiNumerBudynku']}/#{raw_institution['adresDoKorespondecjiNumerLokalu']} #{raw_institution['adresDoKorespondecjiKodPocztowy']}"
        # rubocop:enable Layout/LineLength
        batch_insert_institutions << institution
      end

      Institution.insert_all(batch_insert_institutions)
    end 
  end
end

