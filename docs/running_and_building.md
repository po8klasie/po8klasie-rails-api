# BUILDING
to build the project you need to have docker installed
to build use the command:
docker build -t po8klasie_backend . 
# RUNNING
to run the project you need to have docker and docker-compose installed
to start the databases use the command:
docker-compose up

to run the project use the command
docker run -p 80:80 po8klasie_backend (from built container image) or rails s (locally)
