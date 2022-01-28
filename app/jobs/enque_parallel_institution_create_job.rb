class EnqueParallelInstitutionCreateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    if Institution.count != 0
      Rails.logger.debug 'To execute this job there can be no Institution records in the database'
      puts 'To execute this job there can be no Institution records in the database'
      return
    end

    relevant_institution_types_ids = [93, 94, 45, 96, 14, 15, 17, 15, 27, 26, 20, 16]
    
    for id in relevant_institution_types_ids 
      CreateInstitutionRecordsJob.perform_later(id)
    end
  end
end
