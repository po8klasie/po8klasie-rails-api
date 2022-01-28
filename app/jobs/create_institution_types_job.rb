require 'net/http'    

class CreateInstitutionTypesJob < ApplicationJob
  queue_as :default

  def perform()
    if InstitutionType.count != 0
      puts "database already has institution_types if you want to recreate them, delete them first and then run this job again"
      return
    end

    rspo_api_uri = URI("http://194.54.26.132/api/typ/")
    request = Net::HTTP::Get.new(rspo_api_uri)
    request['accept'] = "application/json"
    res = Net::HTTP.start(rspo_api_uri.hostname, rspo_api_uri.port) {|http|
      http.request(request)
    }
    raw_institution_types = JSON.parse(res.body)

    
    for raw_institurion_type in raw_institution_types
      institution_type = InstitutionType.new
      institution_type.name = raw_institurion_type['name']
      institution_type.rspo_institution_type_id = raw_institurion_type['id'].to_i
      institution_type.save
    end

  end
end
