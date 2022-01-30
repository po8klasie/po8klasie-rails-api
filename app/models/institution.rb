# frozen_string_literal: true

class Institution < ApplicationRecord
  belongs_to :institution_type

  def full_address 
    "#{self.city} #{self.street} #{self.building_no}/#{self.apartment_no} #{self.zip_code}"
  end
end
