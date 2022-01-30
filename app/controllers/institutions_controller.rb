# frozen_string_literal: true

# Controller for reading and filering the school
class InstitutionsController < ApplicationController
  def all_institutions
    pagination_length = extract_pagination_length
    if pagination_length == -1
      render status: :bad_request, json: { message: 'pagination_length must be a positive integer' } and return
    end

    page = extract_page_presence
    institutions = Institution.all.paginate(page: page, per_page: pagination_length)
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

  def extract_pagination_length
    if params['pagination_length'].present?
      pagination_length = params['pagination_length']
      return -1 if pagination_length.to_i < 1
    else
      pagination_length = '10'
    end
    pagination_length
  end

  def extract_page_presence
    params['page'].presence || '1'
  end
end
