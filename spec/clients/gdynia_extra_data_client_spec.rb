# frozen_string_literal: true

require 'rails_helper'

# Field info
# kod,nazwa,komentarz,opis,ikona,jednostka,okres,ostatnia_aktualizacja
# "w92","Liczba etatów przypadających na jednego nauczyciela"
# "w110","Nauczyciele wspomagający"
# "w161","Uczniowie pochodzący spoza Gdyni"
# "w51","Klasy integracyjne"
# "wx1","Aktualny dzienny koszt oświaty"
# "wx2","Liczba sal lekcyjnych"
# "wx3","Oddziały sportowe"
# "w68","Zmianowość"
# "w88","Liczba uczniów na nauczyciela"
# "opis_szkoły","Opis szkoły"
# "sport", "Zajęcia sportowe oferowane przez szkołę"
# "jezyki_obce", "Zajęcia językowe oferowane przez szkołę"
# "profile_klas", "Profile klas które są oferowane przez daną szkołę"
# "zajecia_dodatkowe", "Zajęcia dodatkowe oferowane przez szkołę"

# We are intersted in the following fields: "w51", "wx2", "wx3", "w68", "w88",
# "opis_szkoły",  "sport", "jezyki_obce", "profile_klas", "zajecia_dodatkowe"

# Database fields:
# add_column :institutions, :integration_classes, :integer
# add_column :institutions, :classrooms, :integer
# add_column :institutions, :sport_facilities, :integer
# add_column :institutions, :working_time, :integer
# add_column :institutions, :studerns_per_teacher, :integer
# add_column :institutions, :description, :string
# add_column :institutions, :sports, :string
# add_column :institutions, :foreign_languages, :string
# add_column :institutions, :class_profiles, :string
# add_column :institutions, :extracurricular_activities, :string

RSpec.describe 'GdyniaExtraDataClient' do
  describe '#raw_schools' do
    # We are disabling webmock because we want to connect to the real api

    it 'returns the raw data from the Gdynia API', :allow_net_connect do
      raw_data = GdyniaExtraDataClient.new.raw_schools
      expect(raw_data).to be_a(Array)
      expect(raw_data.size).to be > 0
    end

    it 'correctly processes mock data' do
      institution_type = create(:institution_type)
      institution_1 = create(:institution, institution_type: institution_type)
      institution_2 = create(:institution, institution_type: institution_type)

      mock_response_body = [
        {
          'w51' => 10,
          'wx2' => 20,
          'wx3' => 30,
          'w68' => 40,
          'w88' => 50,
          'rspo' => institution_1.rspo_institution_id,
          'opis_szkoly' => 'Opis szkoły',
          'sport' => %w[koszykówka siatkówka],
          'jezyki_obce' => %w[angielski niemiecki],
          'profile_klas' => %w[matematyczny fizyczny],
          'zajecia_dodatkowe' => %w[chór matematyka]
        },
        {
          'w51' => 101,
          'wx2' => 201,
          'wx3' => 301,
          'w68' => 401,
          'w88' => 501,
          'rspo' => institution_2.rspo_institution_id,
          'opis_szkoly' => 'Opis szkoły',
          'sport' => %w[koszykówka siatkówka],
          'jezyki_obce' => %w[angielski niemiecki],
          'profile_klas' => %w[matematyczny fizyczny],
          'zajecia_dodatkowe' => %w[chór matematyka]
        }
      ]

      stub_request(:get, 'https://edukacja.gdynia.pl/api/schools/?format=json')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: mock_response_body.to_json, headers: {})

      raw_data = GdyniaExtraDataClient.new.raw_schools

      expect(raw_data[0]['w51']).to eq(10)
      expect(raw_data[0]['wx2']).to eq(20)
      expect(raw_data[0]['wx3']).to eq(30)
      expect(raw_data[0]['w68']).to eq(40.0)
      expect(raw_data[0]['w88']).to eq(50.0)
      expect(raw_data[0]['rspo']).to eq(institution_1.rspo_institution_id)

      expect(raw_data[1]['w51']).to eq(101)
      expect(raw_data[1]['wx2']).to eq(201)
      expect(raw_data[1]['wx3']).to eq(301)
      expect(raw_data[1]['w68']).to eq(401.0)
      expect(raw_data[1]['w88']).to eq(501.0)
      expect(raw_data[1]['rspo']).to eq(institution_2.rspo_institution_id)
    end
  end
end
