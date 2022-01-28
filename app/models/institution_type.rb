# frozen_string_literal: true

class InstitutionType < ApplicationRecord
  # create a has many relationship with the institution model
  has_many :institutions, dependent: :restrict_with_error
end
