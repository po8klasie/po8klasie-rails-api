# frozen_string_literal: true

# Controller for reading and filering the school
class InstitutionsController < ApplicationController
  before_action :ensure_page_size_is_positive, :area_query, :name_query, :public_school, :school_rspo_type_ids

  def index
    #rubocop:disable all
    page = extract_page_presence
    institutions = Institution.all
    institutions = institutions.search_by_area(@area_query) if !@area_query.nil?
    institutions = institutions.search_by_name(@name_query) if !@name_query.nil?
    institutions = institutions.where(rspo_institution_type_id: @school_rspo_type_ids) if !@school_rspo_type_ids.nil? 
    institutions = institutions.where(public: @public_school) if !@public_school.nil?

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

  def name_query
    # a string
    @name_query ||= params.fetch(:name_query, nil)
  end

  def area_query
    # a string
    @area_query ||= params.fetch(:area_query, nil)
  end

  def page_size
    # an integer
    @page_size ||= params.fetch(:page_size, 10).to_i
  end

  def public_school
    # boolean value
    @public_school ||= params.fetch(:public_school, nil)
  end

  def school_rspo_type_ids
    # an array of rspo institution type ids
    @school_rspo_type_ids ||= params.fetch(:school_rspo_type_ids, nil)
  end
end
