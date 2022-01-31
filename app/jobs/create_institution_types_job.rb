# frozen_string_literal: true
require 'httparty'

class CreateInstitutionTypesJob < ApplicationJob
  queue_as :default

  def perform
    if InstitutionType.count != 0
      Rails.logger.debug 'To execute this job there can be no InstitutionType records in the database'
      return
    end

    # there is no pagination because there are only 58 institution types
    response = HTTParty.get(
      "#{RSPO_API_BASE}/typ/",
      headers: { 'accept' => 'application/json' }
    )

    raw_institution_types = JSON.parse(response.body)

    raw_institution_types.each do |raw_institurion_type|
      institution_type = InstitutionType.new
      institution_type.name = raw_institurion_type.fetch('nazwa')
      institution_type.rspo_institution_type_id = raw_institurion_type.fetch('id').to_i
      institution_type.save
    end
  end
end
