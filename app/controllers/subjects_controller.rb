class SubjectsController < ApplicationController
    def index 
        @subjects = Subject.all
        render status: '200', json: {
            subjects: @subjects
        }
    end
end
