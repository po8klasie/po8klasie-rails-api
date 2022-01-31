# frozen_string_literal: true

FactoryBot.define do
  factory :institution_type do
    name { Faker::App.name }
    rspo_institution_type_id { Faker::Number.number(digits: 2) }
  end
end
