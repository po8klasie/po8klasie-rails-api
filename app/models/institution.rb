# frozen_string_literal: true

class Institution < ApplicationRecord
  belongs_to :institution_type

  include PgSearch::Model
  pg_search_scope :search_by_name, against: :name
  pg_search_scope :search_by_area, against: %i[county municipality town]

  def address
    "#{town} #{street} #{building_no}/#{apartment_no} #{zip_code}"
  end
end
