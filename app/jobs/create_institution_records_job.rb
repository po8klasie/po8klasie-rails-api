# frozen_string_literal: true

require 'net/http'

class CreateInstitutionRecordsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    if Institution.count != 0
      Rails.logger.debug 'To execute this job there can be no Institution records in the database'
      return
    end

    rspo_api_uri = URI('http://194.54.26.132/api/placowki/')
    request = Net::HTTP::Get.new(rspo_api_uri)
    request['accept'] = 'application/json'
    res = Net::HTTP.start(rspo_api_uri.hostname, rspo_api_uri.port) do |http|
      http.request(request)
    end
    raw_institutions = JSON.parse(res.body)

    raw_institutions.each do |raw_institurion|
      institution = Institution.new
      institution.name = raw_institurion['nazwa']
      institution.rspo_institution_id = raw_institurion['numerRspo']
      institution.public = institution['statusPublicznoPrawny']['nazwa'] == 'publiczna'
      institution.latitude = raw_institurion['geolokalizacja']['latitude'].to_f
      institution.longitude = raw_institurion['geolokalizacja']['longitude'].to_f
      institution.website = raw_institurion['stronaInternetowa']
      institution.email = raw_institurion['email']
      # rubocop:disable Layout/LineLength
      institution.address = raw_institurion["#{raw_institution['adresDoKorespondecjiMiejscowosc']} #{raw_institution['adresDoKorespondecjiUlica']} #{raw_institution['adresDoKorespondecjiNumerBudynku']}/#{raw_institution['adresDoKorespondecjiNumerLokalu']} #{raw_institution['adresDoKorespondecjiKodPocztowy']}"]
      # rubocop:enable Layout/LineLength
      institution.save
    end
  end
end
