# frozen_string_literal: true

# Controller for reading and filering the school
class InstitutionsController < ApplicationController
  before_action :ensure_page_size_is_positive

  def all_institutions
    page = extract_page_presence
    institutions = Institution.all.paginate(page: page, per_page: @page_size)
    render status: '200', json: institutions
  end

  def one_institution
    institution = extract_institution_id
    render status: :bad_request, json: { message: 'id must be present' } and return if institution == -1

    institution = Institution.find_by(id: institution)
    render status: :bad_request, json: { message: 'school does not exists' } and return if institution.nil?

    render status: '200', json: institution
  end

  def extract_institution_id
    if params['id'].present?
      params['id'].to_i
    else
      -1
    end
  end

  def extract_page_presence
    params['page'].presence || '1'
  end

  private

  def ensure_page_size_is_positive
    render status: :unprocessable_entity, json: { message: 'invalid page size' } unless page_size.positive?
  end

  def page_size
    @page_size ||= params.fetch(:page_size, 10).to_i
  end
end
