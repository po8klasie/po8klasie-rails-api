# frozen_string_literal: true

FactoryBot.define do
  factory :institution do
    sequence(:name) { |n| "LO #{n}" }
    public { Faker::Boolean.boolean }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    website { Faker::Internet.url }
    email { Faker::Internet.email }
    street { Faker::Address.street_name }
    building_no { Faker::Address.building_number }
    apartment_no { Faker::Address.secondary_address }
    zip_code { Faker::Address.zip_code }
    institution_type_id { institution_type.id }
    rspo_institution_id { Faker::Number.number(digits: 5) }
    rspo_institution_type_id { institution_type.rspo_institution_type_id }
    county { Faker::Address.state }
    municipality { Faker::Address.city }
    town { Faker::Address.city }
  end
end
