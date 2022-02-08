# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateInstitutionTypesJob, type: :job do
  describe 'When enquiuing a CreateInstitutionTypesJob' do
    it 'adds all institution types to the database if there are no InstitutionType records' do
      WebMock.allow_net_connect!
      CreateInstitutionTypesJob.new.perform
      # if the number of instituion types in the api were to change we want this test to fail
      expect(InstitutionType.count).to eq(58)
      WebMock.disable_net_connect!
    end

    it "doesn't do anything when records are present" do
      InstitutionType.new(name: 'test', rspo_institution_type_id: 1).save
      expect(InstitutionType.count).to eq(1)
      CreateInstitutionTypesJob.new.perform
      expect(InstitutionType.count).to eq(1)
    end
  end
end
