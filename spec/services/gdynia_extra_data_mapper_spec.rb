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

# We are intersted in the following fields: "w51", "wx2", "wx3", "w68", "w88"

# Database fields:
# add_column :institutions, :integration_classes, :integer
# add_column :institutions, :classrooms, :integer
# add_column :institutions, :sport_facilities, :integer
# add_column :institutions, :working_time, :integer
# add_column :institutions, :studerns_per_teacher, :integer

RSpec.describe 'GdyniaExtraDataMapper', type: :service do
  describe '#call' do
    it 'saves the extra data from the GdyniaApi to the database' do
      institution_type = create(:institution_type)
      institution_created = create(:institution, institution_type: institution_type)
      mock_gdynia_api_data = [
        {
          'w51' => 10,
          'wx2' => 20,
          'wx3' => 30,
          'w68' => 40,
          'w88' => 50,
          'rspo' => institution_created.rspo_institution_id
        }
      ]
      GdyniaExtraDataMapper.new.call(mock_gdynia_api_data)
      institution_from_database = Institution.find_by(rspo_institution_id: institution_created.rspo_institution_id)
      expect(institution_from_database.integration_classes).to eq(10)
      expect(institution_from_database.classrooms).to eq(20)
      expect(institution_from_database.sport_facilities).to eq(30)
      expect(institution_from_database.working_time).to eq(40)
      expect(institution_from_database.students_per_teacher).to eq(50)
    end
  end
end
