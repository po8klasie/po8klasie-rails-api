# frozen_string_literal: true

class InstitutionType < ApplicationRecord
  has_many :institutions, dependent: :restrict_with_error
end
