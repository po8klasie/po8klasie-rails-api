class CreateSubjectsService < ApplicationService 
    #This service creates all the subjects that can be included in subject sets. 
    def call  
        #These are the only extended subject fields can be used in subject_sets
        #If there are new subjects that are not in this list it should be updated   
        subject_names = [
            "Polski", 
            "Matematyka", 
            "Fizyka", 
            "Chemia", 
            "Geografia", 
            "Historia", 
            "WOS", 
            "Informatyka", 
            "Biologia", 
            "Sztuka", 
            "Dziennikarstwo", 
            "Prawo", 
            "Medycyna", 
            "Nauki ścisłe", 
            "Ekonomia", 
            "Zarządzanie", 
            "Angielski", 
            "Hiszpański", 
            "Niemiecki", 
            "Historia Sztuki", 
            "Włoski", 
            "Rosyjski", 
            "Francuski", 
            "Gotowanie", 
            "Muzyka", 
            "Technik", 
            "Antyk", 
            "Fotografia", 
            "Złotnik"
        ]

        subject_names.map { |name| Subject.create(name: name) }
    end
end
