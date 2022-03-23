# frozen_string_literal: true

# Controller for reading and filering the school
class InstitutionsController < ApplicationController
  before_action :extract_page_presence, :ensure_page_size_is_positive, :area_query, :name_query, :page_size,
                :public_school, :school_rspo_type_ids, only: [:index]
  before_action :institution_id, only: [:show]
  def index
    institutions = Institution.all
    institutions = institutions.search_by_area(@area_query) unless @area_query.nil?
    institutions = institutions.search_by_name(@name_query) unless @name_query.nil?
    institutions = institutions.where(rspo_institution_type_id: @school_rspo_type_ids) unless @school_rspo_type_ids.nil?
    institutions = institutions.where(public: @public_school) unless @public_school.nil?

    @paginated_institutions = institutions.paginate(page: @page, per_page: @page_size)

    render status: '200', json: {
      "results": @paginated_institutions,
      "page": @page,
      "totalItems": @paginated_institutions.size,
    }
  end

  def show
    render status: :bad_request, json: { message: 'id must be present' } and return if @institution_id.nil?

    institution = Institution.find_by(id: @institution_id)
    render status: :bad_request, json: { message: 'school does not exists' } and return if institution.nil?

    render status: '200', json: institution
  end

  private

  def institution_id
    @institution_id = params.fetch(:id, nil)
  end

  def extract_page_presence
    @page = params.fetch(:page, '1').to_i
    render status: :bad_request, json: { message: 'page must be greater than 0' } if @page < 1
  end

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
