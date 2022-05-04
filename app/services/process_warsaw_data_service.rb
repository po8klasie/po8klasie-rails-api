class ProcessWarsawDataService < ApplicationService 
    #This service processes data provided to us from Warsaw 
    def call  
        #Example school data
        #{
        #    "Dzielnica szkoł": "Mokotów",
        #    "Nazwa szkoły": "XLIX Liceum Ogólnokształcące z Odd. Dwujęzycznymi im. Johanna Wolfganga Goethego",
        #    "Grupa rekrutacyjna/oddział": "1fh [O] geogr-hiszp-mat (hisz*-ang)",
        #    "Minimum": "158,60",
        #    "Maksimum": "179,70",
        #    "Średnia": "164,09"
        #}
        raw_school_data = get_raw_school_data() 

        raw_school_data.each do |raw_school_data_piece|
            institution_name = raw_school_data_piece.fetch("Nazwa szkoły")
            institution = Institution.search_by_name(institution_name)
            if institution.empty?
                puts "No institution found for #{institution_name}"
                next
            elsif institution.count > 1
                puts "more than one institution found for #{institution_name}"
                next
            end

            split_school_subject_data = raw_school_data_piece["Grupa rekrutacyjna/oddział"].split(" ")[2]
            
            subject_names_array = subject_names_array_from_raw_shool_subject_list(split_school_subject_data)
            
            #I know that this looks horrible at a first glance but it's the only way to get 100% coverage
            #on the processable data due to it's very low quality and almost all of that was written 
            #by github copilot
            

            subject_set = SubjectSet.create(institution_id: institution.first.id) 
  
            
            subject_names_array.each do |subject_name|
                #We are sure that all the subject names present in this array are in the database
                subject = Subject.where(name: subject_name)
  
                # we have to check that the subject is present in the database
                if subject.empty?
                    raise "The subject #{subject_name} does not exist in the database, make sure that subjects have been populated"
                # or that there isn't more than one subject with the same name
                elsif subject.count > 1
                    raise "There are more than one subjects with the name #{subject_name}, make sure only one exists in the database"
                end
  
                #The subject variable is an active record relation that we know contains only one record
                subject_set.subjects << subject.first
            end

            WarsawCreateSubjectSetRequirementInfoService.new.call(raw_school_data_piece, subject_set) 
        end
    end

    def get_raw_school_data 
        return JSON.parse(File.read(Rails.root.join('data', 'punkty_warszawa.json')))    
    end

    def subject_names_array_from_raw_shool_subject_list(split_school_subject_data)
        subject_names_array = []

        case split_school_subject_data
            when "fiz-ang-mat"
                subject_names_array = ["Fizyka", "Angielski", "Matematyka"]
            when "mat-geogr-ang"
                subject_names_array = ["Matematyka", "Geografia"]
            when "mat-biol-chem"
                subject_names_array = ["Matematyka", "Biologia", "Chemia"]
            when "biol-ang-pol"
                subject_names_array = ["Biologia", "Angielski", "Polski"]
            when "geogr-ang-hiszp"
                subject_names_array = ["Geografia", "Angielski", "Hiszpański"]
            when "geogr-ang-mat"
                subject_names_array = ["Geografia", "Angielski", "Matematyka"]
            when "biol-chem"
                subject_names_array = ["Biologia", "Chemia"]
            when "pol-wos"
                subject_names_array = ["Polski", "WOS"]
            when "biol-geogr"
                subject_names_array = ["Biologia", "Geografia"]
            when "geogr-wos"
                subject_names_array = ["Geografia", "WOS"]
            when "ang-hiszp-niem"
                subject_names_array = ["Angielski", "Hiszpański", "Niemiecki"]
            when "hist-wos"
                subject_names_array = ["Historia"]
            when "ang-geogr"
                subject_names_array = ["Angielski", "Geografia"]
            when "fiz-mat"
                subject_names_array = ["Fizyka", "Matematyka"]
            when "hist-pol-wos"
                subject_names_array = ["Historia", "Polski", "WOS"]
            when "biol-chem-mat"
                subject_names_array = ["Biologia", "Chemia", "Matematyka"]
            when "geogr-mat"
                subject_names_array = ["Geografia", "Matematyka"]
            when "pol-ang-hiszp"
                subject_names_array = ["Polski", "Angielski", "Hiszpański"]
            when "ang-niem-pol"
                subject_names_array = ["Angielski", "Niemiecki", "Polski"]
            when "ang-pol-mat"
                subject_names_array = ["Angielski", "Polski", "Matematyka"]
            when "hist-ang-pol"
                subject_names_array = ["Historia", "Angielski", "Polski"]
            when "biol-chem-ang"
                subject_names_array = ["Biologia", "Chemia", "Angielski"]
            when "biol-geogr-ang"
                subject_names_array = ["Biologia", "Geografia", "Angielski"]
            when "hist-pol"
                subject_names_array = ["Historia", "Polski"]
            when "inf-ang-mat"
                subject_names_array = ["Informatyka", "Angielski", "Matematyka"]
            when "geogr-ang"
                subject_names_array = ["Geografia", "Angielski"]
            when "inf-mat"
                subject_names_array = ["Informatyka", "Matematyka"]
            when "biol-ang"
                subject_names_array = ["Biologia", "Angielski"]
            when "geogr-ang-niem"
                subject_names_array = ["Geografia", "Angielski", "Niemiecki"]
            when "pol-hist-wos"
                subject_names_array = ["Polski", "Historia", "WOS"]
            when "ang-mat"
                subject_names_array = ["Angielski", "Matematyka"]
            when "h.szt.-pol"
                subject_names_array = ["Historia Sztuki", "Polski"]
            when "geogr-ang-wos"
                subject_names_array = ["Geografia", "Angielski", "WOS"]
            when "ang-mat-inf"
                subject_names_array = ["Angielski", "Matematyka", "Informatyka"]
            when "mat-chem"
                subject_names_array = ["Matematyka", "Chemia"]
            when "mat-wos"
                subject_names_array = ["Matematyka", "WOS"]
            when "mat-geogr"
                subject_names_array = ["Matematyka", "Geografia"]
            when "mat-biol"
                subject_names_array = ["Matematyka", "Biologia"]
            when "hist-pol-wło"
                subject_names_array = ["Historia", "Polski", "Włoski"]
            when "pol-ang-geogr"
                subject_names_array = ["Polski", "Angielski", "Geografia"]
            when "hist-ang-wos"
                subject_names_array = ["Historia", "Angielski", "WOS"]
            when "hist-wos-ang"
                subject_names_array = ["Historia", "WOS", "Angielski"]
            when "fiz-inf-mat"
                subject_names_array = ["Fizyka", "Informatyka", "Matematyka"]
            when "geogr-niem-mat"
                subject_names_array = ["Geografia", "Niemiecki", "Matematyka"]
            when "geogr-ros-mat"
                subject_names_array = ["Geografia", "Rosyjski", "Matematyka"]
            when "geogr-hist-"
                subject_names_array = ["Geografia", "Historia"]
            when "mat-geogr-hiszp"
                subject_names_array = ["Matematyka", "Geografia", "Hiszpański"]
            when "biol-chem-hiszp"
                subject_names_array = ["Biologia", "Chemia", "Hiszpański"]
            when "pol-hist-h.szt."
                subject_names_array = ["Polski", "Historia", "Historia Sztuki"]
            when "pol-wos-hiszp"
                subject_names_array = ["Polski", "WOS", "Hiszpański"]
            when "ang-pol"
                subject_names_array = ["Angielski", "Polski"]
            when "pol-hist"
                subject_names_array = ["Polski", "Historia"]
            when "geogr-hiszp-mat"
                subject_names_array = ["Geografia", "Hiszpański", "Matematyka"]
            when "hist-franc"
                subject_names_array = ["Historia", "Francuski"]
            when "hist-niem"
                subject_names_array = ["Historia", "Niemiecki"]
            when "Kucharz"
                subject_names_array = ["Gotowanie"]
            when "(ang*-niem*)"
                subject_names_array = ["Angielski", "Niemiecki"]
            when "biol-ang-mat"
                subject_names_array = ["Biologia", "Angielski", "Matematyka"]
            when "geogr-mat-wos"
                subject_names_array = ["Geografia", "Matematyka", "WOS"]
            when "chem-fiz-mat"
                subject_names_array = ["Chemia", "Fizyka", "Matematyka"]
            when "geogr-hiszp-wos"
                subject_names_array = ["Geografia", "Hiszpański", "WOS"]
            when "ang-pol-wos"
                subject_names_array = ["Angielski", "Polski", "WOS"]
            when "geogr-mat-ang"
                subject_names_array = ["Geografia", "Matematyka", "Angielski"]
            when "(ang-hisz*)"
                subject_names_array = ["Angielski", "Hiszpański"]
            when "ang-biol-geogr"
                subject_names_array = ["Angielski", "Biologia", "Geografia"]
            when "mat-fiz-inf"
                subject_names_array = ["Matematyka", "Fizyka", "Informatyka"]
            when "inf-pol-ang"
                subject_names_array = ["Informatyka", "Polski", "Angielski"]
            when "ang-inf-wos"
                subject_names_array = ["Angielski", "Informatyka", "WOS"]
            when "geogr-ang-pol"
                subject_names_array = ["Geografia", "Angielski", "Polski"]
            when "hist-mat-wos"
                subject_names_array = ["Historia", "Matematyka", "WOS"]
            when "mat-fiz-chem"
                subject_names_array = ["Matematyka", "Fizyka", "Chemia"]
            when "inf-ang"
                subject_names_array = ["Informatyka", "Angielski"]
            when "geogr-hist-mat"
                subject_names_array = ["Geografia", "Historia", "Matematyka"]
            when "h.muz.-"
                subject_names_array = ["Muzyka"]
            when "h.muz.-pol"
                subject_names_array = ["Muzyka", "Polski"]
            when "geogr-franc-"
                subject_names_array = ["Geografia", "Francuski"]
            when "geogr-hiszp-"
                subject_names_array = ["Geografia", "Hiszpański"]
            when "geogr-niem-"
                subject_names_array = ["Geografia", "Niemiecki"]
            when "hist-franc-"
                subject_names_array = ["Historia", "Francuski"]
            when "hist-hiszp-"
                subject_names_array = ["Historia", "Hiszpański"]
            when "hist-niem-"
                subject_names_array = ["Historia", "Niemiecki"]
            when "hist-h.szt.-pol"
                subject_names_array = ["Historia", "Historia Sztuki", "Polski"]
            when "ang-hiszp-pol"
                subject_names_array = ["Angielski", "Hiszpański", "Polski"]
            when "Technik"
                subject_names_array = ["Technik"]
            when "h.szt.-ang-pol"
                subject_names_array = ["Historia Sztuki", "Angielski", "Polski"]
            when "ang-antyk-pol"
                subject_names_array = ["Angielski", "Antyk", "Polski"]
            when "hist-franc-pol"
                subject_names_array = ["Historia", "Francuski", "Polski"]
            when "geogr-franc-pol"
                subject_names_array = ["Geografia", "Francuski", "Polski"]
            when "hist-antyk-pol"
                subject_names_array = ["Historia", "Antyk", "Polski"]
            when "franc"
                subject_names_array = ["Francuski"]
            when "(niem-ang)"
                subject_names_array = ["Niemiecki", "Angielski"]
            when "ang-pol-wło"
                subject_names_array = ["Angielski", "Polski", "Włoski"]
            when "hiszp-ang-geogr"
                subject_names_array = ["Hiszpański", "Angielski", "Geografia"]
            when "niem-ang-geogr"
                subject_names_array = ["Niemiecki", "Angielski", "Geografia"]
            when "biol-chem-obcy"
                subject_names_array = ["Biologia", "Chemia"]
            when "biol-obcy-pol"
                subject_names_array = ["Biologia", "Polski"]
            when "hist-obcy-pol"
                subject_names_array = ["Historia", "Polski"]
            when "wielozawodowa"
                subject_names_array = []
            when "mat-ang"
                subject_names_array = ["Matematyka", "Angielski"]
            when "biol-ang-"
                subject_names_array = ["Biologia", "Angielski"]
            when "mat-geogr-niem"
                subject_names_array = ["Matematyka", "Geografia", "Niemiecki"]
            when "pol-hist-ang"
                subject_names_array = ["Polski", "Historia", "Angielski"]
            when "ang-geogr-wos"
                subject_names_array = ["Angielski", "Geografia", "Włoski"]
            when "ang-hiszp-mat"
                subject_names_array = ["Angielski", "Hiszpański", "Matematyka"]
            when "ang-mat-wło"
                subject_names_array = ["Angielski", "Matematyka", "Włoski"]
            when "ang-geogr-mat"
                subject_names_array = ["Angielski", "Geografia", "Matematyka"]
            when "ang-mat-fiz"
                subject_names_array = ["Angielski", "Matematyka", "Fizyka"]
            when "hist-inf-ang"
                subject_names_array = ["Historia", "Informatyka", "Angielski"]
            when "Fotograf"
                subject_names_array = ["Fotografia"]
            when "hist-ang"
                subject_names_array = ["Historia", "Angielski"]
            when "pol-hist-hiszp"
                subject_names_array = ["Polski", "Historia", "Hiszpański"]
            when "mat-inf-fiz"
                subject_names_array = ["Matematyka", "Informatyka", "Fizyka"]
            when "pol-wos-ang"
                subject_names_array = ["Polski", "Włoski", "Angielski"]
            when "ang-wos"
                subject_names_array = ["Angielski", "Włoski"]
            when "chem-mat"
                subject_names_array = ["Chemia", "Matematyka"]
            when "ang-pol-hist-wos"
                subject_names_array = ["Angielski", "Polski", "Historia", "Włoski"]
            when "mat-inf-ang"
                subject_names_array = ["Matematyka", "Informatyka", "Angielski"]
            when "geogr-franc-mat"
                subject_names_array = ["Geografia", "Francuski", "Matematyka"]
            when "ang-franc-mat"
                subject_names_array = ["Angielski", "Francuski", "Matematyka"]
            when "ang-mat-wło-wos"
                subject_names_array = ["Angielski", "Matematyka", "Włoski", "WOS"]
            when "ang-niem-mat"
                subject_names_array = ["Angielski", "Niemiecki", "Matematyka"]
            when "geogr-hiszp-pol"
                subject_names_array = ["Geografia", "Hiszpański", "Polski"]
            when "geogr-niem-pol"
                subject_names_array = ["Geografia", "Niemiecki", "Polski"]
            when "(ang-fra*,hisz*,niem*)"
                subject_names_array = ["Angielski", "Francuski", "Hiszpański", "Niemiecki"]
            when "Złotnik-jubiler"
                subject_names_array = ["Złotnik"]
            when "ang-biol-wos"
                subject_names_array = ["Angielski", "Biologia", "Włoski"]
            when "h.szt.-ang-"
                subject_names_array = ["Hiszpański", "Angielski"]
            when "ang"
                subject_names_array = ["Angielski"]
            when "niem"
                subject_names_array = ["Niemiecki"]
            when "hiszp"
                subject_names_array = ["Hiszpański"]
            when "(fra-ang)"
                subject_names_array = ["Francuski", "Angielski"]
            when "geogr-hist-wos"
                subject_names_array = ["Geografia", "Historia", "Włoski"]
        end

        return subject_names_array
    end
end
