# frozen_string_literal: true

class Institution < ApplicationRecord
  belongs_to :institution_type

  def address
    "#{city} #{street} #{building_no}/#{apartment_no} #{zip_code}"
  end
end
