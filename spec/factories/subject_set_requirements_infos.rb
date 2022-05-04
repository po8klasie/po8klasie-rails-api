# frozen_string_literal: true

FactoryBot.define do
  #remember to specify the subject set that this object belongs to
  factory :subject_set_requirements_info do
    min_points { 156.1 }
    max_points { 179.7 }
    average_points { 164.09 }
  end
end
