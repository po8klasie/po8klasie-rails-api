#This script should be run using rails runner not ruby

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