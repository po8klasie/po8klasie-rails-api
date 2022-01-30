FactoryBot.define do
    factory :institution do
      name { Faker::FunnyName.name }
      public { Faker::Boolean.boolean }
      latitude { Faker::Address.latitude }
      longitude { Faker::Address.longitude }
      website { Faker::Internet.url }
      email { Faker::Internet.email }
      city { Faker::Address.city }
      street { Faker::Address.street_name }
      building_no { Faker::Address.building_number }
      apartment_no { Faker::Address.secondary_address }
      zip_code { Faker::Address.zip_code }
      institution_type_id { institution_type.id }
      rspo_institution_id { institution_type.rspo_institution_type_id }
    end
  end
  