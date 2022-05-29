# frozen_string_literal: true

class CreateSubjectsJob < ApplicationJob
    queue_as :default
  
    def perform()
        CreateSubjectsService.new.call
    end
end
  