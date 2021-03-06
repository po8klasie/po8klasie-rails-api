# Institutions

### Index
GET /institutions 
returns a paginated list of institutions

parameters:
page:int, optional, default='1'
it specifies the page number to be used for pagination

name_query:string, optional, default=null
it specifies the full name of the institution to be used for filtering

area_query:string "powiat gmina miejscowosc", optional, default=null, example: "Żywiec", "Warszawa"
it specifies the area, the search is performed on fields of county municipality town

public_school:bool, optional, default=null
it specifies whether schools have to be public or not public 

school_rspo_type_ids: array of ints, optional, default=null
it specifies the types of schools to be considered

class_profiles: string, optional, default=null
it specifies the class profiles to be considere separated by commas

sports: string, optional, default=null
it specifies the sports to be considere separated by commas

foreign_languages: string, optional, default=null
it specifies the foreign_languages to be considere separated by commas

extracurricular_activities: string, optional, default=null
it specifies the extracurricular activities to be considere separated by commas

page_size:string, optional, default='10'
it specifies the pagination size.
Please remember to keep the page_size consistent between api calls from the same client
because changing it during a session may result in showing the users schools that have already been shown or skipping some of them

### Show
GET /institutions/:id

paramenters:
id:int, required
it specifies the internal id of the institution to be shown
this is not the RSPO id of the institution


### Institution model 

in the institution model the data that comes from Gdyania API as a list is joined using a comma. for example 

"zajecia_dodatkowe": [
            "klub turystyczny",
            "sekcja karate"
        ]

institution_from_gdynia.exatracurricular_activities will return "klub turystyczny,sekcja karate"
