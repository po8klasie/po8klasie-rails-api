# frozen_string_literal: true

class ApplicationController < ActionController::Base
  respond_to :html, :json
  protect_from_forgery with: :null_session, only: proc { |c| c.request.format.json? }
end
