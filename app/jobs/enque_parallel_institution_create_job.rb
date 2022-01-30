# frozen_string_literal: true

class EnqueParallelInstitutionCreateJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    if Institution.count != 0
      Rails.logger.debug 'To execute this job there can be no Institution records in the database'
      return
    end

    # 93 => "Branżowa szkoła I stopnia"
    # 94 => "Branżowa szkoła II stopnia"
    # 45 => "Centrum Kształcenia Praktycznego"
    # 96 => "Centrum Kształcenia Zawodowego"
    # 14 => "Liceum ogólnokształcące"
    # 17 => "Liceum ogólnokształcące uzupełniające dla absolwentów zasadniczych szkół zawodowych"
    # 15 => "Liceum profilowane"
    # 27 => "Liceum sztuk plastycznych"
    # 26 => "Ogólnokształcąca szkoła sztuk pięknych"
    # 20 => "Szkoła specjalna przysposabiająca do pracy"
    # 16 => "Technikum"
    relevant_institution_types_ids = [93, 94, 45, 96, 14, 17, 15, 27, 26, 20, 16]

    relevant_institution_types_ids.each do |id|
      CreateInstitutionRecordsJob.perform_later(id)
    end
  end
end
