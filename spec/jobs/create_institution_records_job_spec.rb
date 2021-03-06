# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateInstitutionRecordsJob, type: :job do
  describe 'after enqueuing the job' do
    it 'adds the institutions from the RSPO API to the database from a given type', :allow_net_connect do
      CreateInstitutionTypesJob.new.perform
      CreateInstitutionRecordsJob.new.perform(27)
      expect(Institution.where(rspo_institution_type_id: 27).count).to eq(62)
      expect(Institution.where(rspo_institution_type_id: 27).map(&:rspo_institution_id).uniq.count).to eq(62)
    end
  end
end
