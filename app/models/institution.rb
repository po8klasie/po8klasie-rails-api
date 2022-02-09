# frozen_string_literal: true

class Institution < ApplicationRecord
  belongs_to :institution_type

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name
  
  def address
    "#{city} #{street} #{building_no}/#{apartment_no} #{zip_code}"
  end
end
