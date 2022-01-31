# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Institution, type: :model do
  describe 'methods' do
    it "has a full address method from it's components" do
      type = create(:institution_type)
      i = create(:institution, institution_type: type, city: 'Bielsko Biała', street: 'Królewska', building_no: '1',
                               apartment_no: '6', zip_code: '44-100')
      expect(i.address).to eq('Bielsko Biała Królewska 1/6 44-100')
    end
  end
end
