# Institutions

### Index
GET /institutions 
returns a paginated list of institutions

parameters:
page:string, optional, default='1'
it specifies the page number to be used for pagination

pg_name_querry:string, optional, default=null
it specifies the full name of the institution to be used for filtering

pg_area_querry:string "powiat gmina miejscowosc", optional, default=null, example: "Żywiec", "Warszawa"
it specifies the area, the search is performed on fields of powiat gmina miejscowosc

public_school:bool, optional, default=null
it specifies whether schools have to be public or not public 

school_rspo_type_ids: array of ints, optional, default=null
it specifies the types of schools to be considered

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
