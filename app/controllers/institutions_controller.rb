# frozen_string_literal: true

# Controller for reading and filering the school
class InstitutionsController < ApplicationController
  before_action :ensure_page_size_is_positive, :pg_area_querry, :pg_name_querry, :school_status, :school_rspo_type_ids

  def index
    #rubocop:disable all
    page = extract_page_presence
    institutions = Institution.all
    institutions = institutions.search_by_area(@pg_area_querry) if !@pg_area_querry.nil?
    institutions = institutions.search_by_name(@pg_name_querry) if !@pg_name_querry.nil?
    institutions = institutions.where(rspo_institution_type_id: @school_rspo_type_ids) if !@school_rspo_type_ids.nil? 
    institutions = institutions.where(public: @school_status) if !@school_status.nil?

    render status: '200', json: institutions.paginate(page: page, per_page: @page_size)
    #rubocop:enable all
  end

  def show
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

  def pg_name_querry
    # a string
    @pg_name_querry ||= params.fetch(:pg_name_querry, nil)
  end

  def pg_area_querry
    # a string
    @pg_area_querry ||= params.fetch(:pg_area_querry, nil)
  end

  def page_size
    # an integer
    @page_size ||= params.fetch(:page_size, 10).to_i
  end

  def school_status
    # boolean value
    @school_status ||= params.fetch(:school_status, nil)
  end

  def school_rspo_type_ids
    # an array of rspo institution type ids
    @school_rspo_type_ids ||= params.fetch(:school_rspo_type_ids, nil)
  end
end
