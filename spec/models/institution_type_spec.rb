# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InstitutionType, type: :model do
  describe 'relations' do
    it 'has many institutions' do
      type = create(:institution_type)
      create_list(:institution, 10, institution_type: type)
      expect(type.institutions.count).to eq(10)
    end

    it 'has many institutions through the rspo_institution_type_id foreign key' do
      type = create(:institution_type)
      create_list(:institution, 10, institution_type: type)
      expect(Institution.where(rspo_institution_type_id: type.rspo_institution_type_id).count).to eq(10)
    end
  end
end
