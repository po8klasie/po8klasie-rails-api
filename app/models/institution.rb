# frozen_string_literal: true

class Institution < ApplicationRecord
  belongs_to :institution_type

  include PgSearch::Model

  pg_search_scope :search_by_name, against: :name, using: :dmetaphone
  pg_search_scope :search_by_area, against: %i[county municipality town]
  pg_search_scope :search_by_class_profiles, against: :class_profiles, using: {tsearch: {any_word: true} }
  pg_search_scope :search_by_sports, against: :sports, using: {tsearch: {any_word: true} }
  pg_search_scope :search_by_foreign_languages, against: :foreign_languages, using: {tsearch: {any_word: true} }
  pg_search_scope :search_by_extracurricular_activities, against: :extracurricular_activities, using: {tsearch: {any_word: true} }

  
  def address
    "#{town} #{street} #{building_no}/#{apartment_no} #{zip_code}"
  end
end
