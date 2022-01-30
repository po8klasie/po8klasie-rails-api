# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Institution, type: :model do
  describe 'methods' do
    it "has a full address method from it's components" do
      type = create(:institution_type)
      i = create(:institution, institution_type: type)
      expect(i.address).to eq("#{i.city} #{i.street} #{i.building_no}/#{i.apartment_no} #{i.zip_code}")
    end
  end
end
