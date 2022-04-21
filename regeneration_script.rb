#This script should be run using rails runner not ruby

#How to use this script in cicd:

# - first make sure that all the env variables required for accessing the production db are present in the application docker container 
#(I'm assuming that this is how we are going to run this because there everything is already prepared and installed), that would be DATABASE_HOST, 
#DATABASE_NAME, DATABASE_USER, DATABASE_PASSWORD

# - second make sure that the server is running in the production mode in the background using RAILS_ENV=production rails s -b 127.0.0.1

# - third start the script in the production mode using RAILS_ENV=production rails r regeneration_script.rb



#we don't want to log from queries we are running in this scirpt
ActiveRecord::Base.logger = nil


#This function waits until all jobs have finished and we can proceed to the next step of the process. 
def wait_for_all_jobs_to_finish(job_name)
    
    counter = 0
    loop {
        jobs_left = GoodJob::Execution.display_all.size
        if jobs_left == 0
            puts "#{job_name} finished and took #{1 * counter} seconds"
            break 
        else 
            puts "waiting for #{job_name} to finish, #{1 * counter} seconds elapsed, there are #{jobs_left} jobs to be finished"
            sleep(1)
        end 

        counter += 1
    }
end 

puts "started running migrations"

#run all migrations 
system("rails", "db:migrate")

puts "finished running migrations"

#First delete all existing institution types and institutions
puts "deleted all institutions and insitutions types"
Institution.delete_all 
InstitutionType.delete_all

puts "started CreateInstitutionTypesJob job"
#Create new types from the RSPO API 
CreateInstitutionTypesJob.perform_now
wait_for_all_jobs_to_finish("CreateInstitutionTypesJob")

puts "started EnqueParallelInstitutionCreateJob job"

#Create Instituions from RSPO API 
EnqueParallelInstitutionCreateJob.perform_now
wait_for_all_jobs_to_finish("EnqueParallelInstitutionCreateJob")

puts "started CreateGdyniaExtraDataRecordsJob jobs"

#Fill the existing records with extra data from Gdynia API 
CreateGdyniaExtraDataRecordsJob.perform_now
wait_for_all_jobs_to_finish("CreateGdyniaExtraDataRecordsJob")


puts "finished"
