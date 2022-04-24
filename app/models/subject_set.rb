# frozen_string_literal: true

class SubjectSet < ApplicationRecord
  has_one :subject_set_requirements_info, dependent: :destroy
  belongs_to :institution
  has_and_belongs_to_many :subjects
end
