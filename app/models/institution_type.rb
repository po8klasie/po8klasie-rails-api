class InstitutionType < ApplicationRecord
    #create a has many relationship with the institution model
    has_many :institutions
end
