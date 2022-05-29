class WarsawCreateSubjectSetRequirementInfoService < ApplicationService
    #Example school data
    #{
    #    "Dzielnica szkoł": "Mokotów",
    #    "Nazwa szkoły": "XLIX Liceum Ogólnokształcące z Odd. Dwujęzycznymi im. Johanna Wolfganga Goethego",
    #    "Grupa rekrutacyjna/oddział": "1fh [O] geogr-hiszp-mat (hisz*-ang)",
    #    "Minimum": "158,60",
    #    "Maksimum": "179,70",
    #    "Średnia": "164,09"
    #}

    def call(raw_school_data_piece, subject_set) 
        subject_set_requirements_info = SubjectSetRequirementsInfo.new(subject_set_id: subject_set.id)
        subject_set_requirements_info.min_points = raw_school_data_piece["Minimum"].gsub(",", ".").to_f 
        subject_set_requirements_info.max_points = raw_school_data_piece["Maksimum"].gsub(",", ".").to_f
        subject_set_requirements_info.average_points = raw_school_data_piece["Średnia"].gsub(",", ".").to_f
        subject_set_requirements_info.save
    end
end
