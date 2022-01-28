# frozen_string_literal: true

require 'net/http'

class CreateInstitutionTypesJob < ApplicationJob
  queue_as :default

  def perform
    if InstitutionType.count != 0
      Rails.logger.debug 'To execute this job there can be no InstitutionType records in the database'
      Rails.logger.debug 'To execute this job there can be no InstitutionType records in the database'
      return
    end

    rspo_api_uri = URI('http://194.54.26.132/api/typ/')
    request = Net::HTTP::Get.new(rspo_api_uri)
    request['accept'] = 'application/json'
    res = Net::HTTP.start(rspo_api_uri.hostname, rspo_api_uri.port) do |http|
      http.request(request)
    end
    raw_institution_types = JSON.parse(res.body)

    raw_institution_types.each do |raw_institurion_type|
      institution_type = InstitutionType.new
      institution_type.name = raw_institurion_type['nazwa']
      institution_type.rspo_institution_type_id = raw_institurion_type['id'].to_i
      institution_type.save
    end
  end
end
