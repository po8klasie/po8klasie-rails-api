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

=begin
 ["fiz-ang-mat",
 "mat-fiz-ang",
 "mat-geogr-ang",
 "mat-biol-chem",
 "biol-ang-pol",
 "geogr-ang-hiszp",
 "geogr-ang-mat",
 "biol-chem",
 "pol-wos",
 "biol-geogr",
 "geogr-wos",
 "ang-hiszp-niem",
 "hist-wos",
 "ang-geogr",
 "fiz-mat",
 "hist-pol-wos",
 "biol-chem-mat",
 "geogr-mat",
 "pol-ang-hiszp",
 "ang-niem-pol",
 "ang-pol-mat",
 "hist-ang-pol",
 "biol-chem-ang",
 "biol-geogr-ang",
 "hist-pol",
 "inf-ang-mat",
 "geogr-ang",
 "inf-mat",
 "biol-ang",
 "geogr-ang-niem",
 "pol-hist-wos",
 "ang-mat",
 "h.szt.-pol",
 "geogr-ang-wos",
 "ang-mat-inf",
 "mat-chem",
 "mat-wos",
 "mat-geogr",
 "mat-biol",
 "hist-pol-wło",
 "pol-ang-geogr",
 "hist-ang-wos",
 "hist-wos-ang",
 "fiz-inf-mat",
 "geogr-niem-mat",
 "geogr-ros-mat",
 "geogr-hist-",
 "mat-geogr-hiszp",
 "biol-chem-hiszp",
 "pol-hist-h.szt.",
 "pol-wos-hiszp",
 "ang-pol",
 "pol-hist",
 "geogr-hiszp-mat",
 "hist-franc",
 "hist-niem",
 "Kucharz",
 "Cukiernik",
 "(ang*-niem*)",
 "biol-ang-mat",
 "geogr-mat-wos",
 "chem-fiz-mat",
 "geogr-hiszp-wos",
 "ang-pol-wos",
 "geogr-mat-ang",
 "(ang-hisz*)",
 "ang-biol-geogr",
 "mat-fiz-inf",
 "inf-pol-ang",
 "ang-inf-wos",
 "geogr-ang-pol",
 "hist-mat-wos",
 "mat-fiz-chem",
 "inf-ang",
 "geogr-hist-mat",
 "h.muz.-",
 "h.muz.-pol",
 "geogr-franc-",
 "geogr-hiszp-",
 "geogr-niem-",
 "hist-franc-",
 "hist-hiszp-",
 "hist-niem-",
 "hist-h.szt.-pol",
 "ang-hiszp-pol",
 "Technik",
 "h.szt.-ang-pol",
 "ang-antyk-pol",
 "hist-franc-pol",
 "geogr-franc-pol",
 "hist-antyk-pol",
 "franc",
 "(niem-ang)",
 "ang-pol-wło",
 "hiszp-ang-geogr",
 "niem-ang-geogr",
 "biol-chem-obcy",
 "biol-obcy-pol",
 "hist-obcy-pol",
 "wielozawodowa",
 "mat-ang",
 "biol-ang-",
 "mat-geogr-niem",
 "pol-hist-ang",
 "ang-geogr-wos",
 "ang-hiszp-mat",
 "ang-mat-wło",
 "ang-geogr-mat",
 "ang-mat-fiz",
 "hist-inf-ang",
 "Fotograf",
 "hist-ang",
 "pol-hist-hiszp",
 "mat-inf-fiz",
 "pol-wos-ang",
 "ang-wos",
 "chem-mat",
 "ang-pol-hist-wos",
 "mat-inf-ang",
 "geogr-franc-mat",
 "ang-franc-mat",
 "ang-niem-mat",
 "geogr-hiszp-pol",
 "geogr-niem-pol",
 "(ang-fra*,hisz*,niem*)",
 "Złotnik-jubiler",
 "ang-biol-wos",
 "h.szt.-ang-",
 "ang",
 "niem",
 "hiszp",
 "(fra-ang)",
 "geogr-hist-wos"]
=end

        raw_school_data = JSON.parse(File.read(Rails.root.join('data', 'punkty_warszawa.json')))       

        processable_schools = 0
        subject_combinations = []
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

            processable_schools += 1

            split_school_subject_data = raw_school_data_piece["Grupa rekrutacyjna/oddział"].split(" ")

            subject_combinations << split_school_subject_data[2]

            #subject_set = SubjectSet.create(institution_id: institution.first.id)

        end

        debugger
    end
end
