When the data from one of the data providers changes you should regenerate the database from scratch.

Steps for regenerating the database:
 - clone this repository
 - create a new branch named like 21_01_2020_data_regeneration
 - change the database field in the production config to the database_1 if database_2 is present or vice versa.
 - Start the server locally with rails s -e production
 - Enter rails console using rails c -e production in separate terminal
 - Delete all Institution objects in the database using Institution.delete_all
 - Start the job to create the institution types by running the CreateInstitutionTypesJob.new.perform_now(). Wait for it to finish.
 - Start the job to pull the records from the RSPO API using EnqueParallelInstitutionCreateJob.new.perform_now(). After that you have to wait for all the jobs for the separate institution types to finish (look at the server output log)
 - Start the job to pull the records from the Gdynia API using the CreateGdyniaExtraDataRecordsJob.new.perform_now(). After that you have to wait for it to finish. (look at the server output log)
 - If any of the jobs failed you can try again. but remember to clear the Institition objects first using Institution.delete_all and start from the first one. 
 - Create a pull request with the changes you made. Create it only after all jobs succeded.
 - After the pull request is merged clear the Cloudflare cache using the "Clear cloudflare cache" workflow in Github Actions. 

