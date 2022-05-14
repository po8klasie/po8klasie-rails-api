# frozen_string_literal: true

class ProcessWarsawDataJob < ApplicationJob
    queue_as :default
  
    def perform()
        ProcessWarsawDataService.new.call
    end
end
  