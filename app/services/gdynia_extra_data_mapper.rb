# frozen_string_literal: true

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
class GdyniaExtraDataMapper < ApplicationService
  def call(raw_data)
    raw_data.each do |raw_school|
      rspo_match = Institution.find_by(rspo_institution_id: raw_school.fetch('rspo'))

      if rspo_match.nil?
        # not every school that has a valid rspo_institution_id is in the database
        # for example primary schools have a rspo_institution_id but are not in the database
        next
      end

      rspo_match[:integration_classes] = raw_school.fetch('w51')
      rspo_match[:classrooms] = raw_school.fetch('wx2')
      rspo_match[:sport_facilities] = raw_school.fetch('wx3')
      rspo_match[:working_time] = raw_school.fetch('w68')
      rspo_match[:students_per_teacher] = raw_school.fetch('w88')
      rspo_match[:description] = raw_school.fetch('opis_szkoly')
      rspo_match[:sports] = raw_school.fetch('sport').join(',')
      rspo_match[:foreign_languages] = raw_school.fetch('jezyki_obce').join(',')
      rspo_match[:extracurricular_activities] = raw_school.fetch('zajecia_dodatkowe').join(',')
      
      rspo_match.save

      class_profiles = raw_school.fetch('profile_klas') 
      if class_profiles != "" &&  class_profiles.size != 0
        class_profiles.each do |class_profile| 
          subject_set = SubjectSet.create(institution_id: rspo_match.id) 
          subject_names = gdynia_class_profile_to_subject_names_array(class_profile)

          subject_names.each do |subject_name|
            subject = Subject.where(name: subject_name)

            if subject.empty?
              raise "The subject #{subject_name} does not exist in the database, make sure that subjects have been populated"
            elsif subject.count > 1
              raise "There are more than one subjects with the name #{subject_name}, make sure only one exists in the database"
            end

            subject_set.subjects << subject
          end
        end
      end
    end
  end

  def gdynia_class_profile_to_subject_names_array(class_profile)
    subject_names_array = []
    
    case class_profile
      when "matematyczna"
        subject_names_array << "Matematyka"
      when "biologiczna"
        subject_names_array << "Biologia"
      when "artystyczna"
        subject_names_array << "Sztuka"
      when "dziennikarsko-prawnicza"
        subject_names_array << "Dziennikarstwo"
        subject_names_array << "Prawo"
      when "politechniczna"
        subject_names_array << "Nauki ścisłe"
      when "medyczna"
        subject_names_array << "Medycyna"
      when "informatyczna"
        subject_names_array << "Informatyka"
      when "ekonomiczno-menadżerska"
        subject_names_array << "Ekonomia"
        subject_names_array << "Zarządzanie"
      when "dziennikarsko-prawnicza"
        subject_names_array << "Dziennikarstwo"
        subject_names_array << "Prawo"
    end

    return subject_names_array
  end
end
