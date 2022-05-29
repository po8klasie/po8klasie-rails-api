# frozen_string_literal: true

class ProcessWarsawDataJobV2 < ApplicationJob
    queue_as :default
  
    def perform()
        ProcessWarsawDataServiceV2.new.call
    end
end
  