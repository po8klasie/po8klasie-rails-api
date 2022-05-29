# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CreateSubjectsService', type: :service do
  describe '#call' do
    it 'creates the SubjectSetRequirementInfo object in the db' do
        #Setup
        raw_school_data_piece =  {
                "Dzielnica szkoł" => "Mokotów",
                "Nazwa szkoły" => "XLIX Liceum Ogólnokształcące z Odd. Dwujęzycznymi im. Johanna Wolfganga Goethego",
                "Grupa rekrutacyjna/oddział" => "1fh [O] geogr-hiszp-mat (hisz*-ang)",
                "Minimum" => "158,60",
                "Maksimum" => "179,70",
                "Średnia" => "164,09"
            }
        institution_type = create(:institution_type)
        institution_created = create(:institution, institution_type: institution_type)
        subject_set = SubjectSet.create(institution_id: institution_created.id)

        #Test
        WarsawCreateSubjectSetRequirementInfoService.new.call(raw_school_data_piece, subject_set)

        #Expectations
        expect(SubjectSetRequirementsInfo.count).to eq(1)
        expect(subject_set.subject_set_requirements_info).not_to be_nil()

        created_subject_set_requirement_info = subject_set.subject_set_requirements_info  
        expect(created_subject_set_requirement_info.min_points).to eq(158.6)
        expect(created_subject_set_requirement_info.max_points).to eq(179.7)
        expect(created_subject_set_requirement_info.average_points).to eq(164.09)
    end
  end
end
