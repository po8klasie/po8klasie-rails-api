# Institutions

### Index
GET /institutions 
returns a paginated list of institutions

parameters:
page:string, optional, default='1'
it specifies the page number to be used for pagination

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
