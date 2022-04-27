# frozen_string_literal: true

# Controller for reading and filering the school
class InstitutionsController < ApplicationController
  before_action :extract_page_presence, :ensure_page_size_is_positive, :area_query, :name_query, :page_size,
                :public_school, :school_rspo_type_ids, :class_profiles, :sports,
                :foreign_languages, :extracurricular_activities, only: [:index]
  before_action :institution_id, only: [:show]
  def index
    institutions = Institution.all
    institutions = institutions.search_by_area(@area_query) unless @area_query.nil?
    institutions = institutions.search_by_name(@name_query) unless @name_query.nil?
    institutions = institutions.where(rspo_institution_type_id: @school_rspo_type_ids) unless @school_rspo_type_ids.nil?
    institutions = institutions.where(public: @public_school) unless @public_school.nil?
    institutions = institutions.search_by_sports(@sports) unless @sports.nil?
    institutions = institutions.search_by_foreign_languages(@foreign_languages) unless @foreign_languages.nil?
    institutions = institutions.search_by_extracurricular_activities(@extracurricular_activities) unless @extracurricular_activities.nil?

    if @class_profiles != nil 
      if @class_profiles.size > 1
        @class_profiles_pg_array = "{"
        @class_profiles.each_with_index  do |profile, index|
          if index != @class_profiles.length - 1
            @class_profiles_pg_array += profile + ","
          else 
            @class_profiles_pg_array += profile
          end
        end 
        @class_profiles_pg_array += "}"
      else 
        @class_profiles_pg_array = "{" + @class_profiles[0] + "}"
      end
      
      institutions = institutions.joins(subject_sets: :subjects).group(:id).having("ARRAY_AGG(subjects.name::text) @> ?", @class_profiles_pg_array)
    end

    institutions_count = institutions.count.size
    
    @paginated_institutions = institutions.paginate(page: @page, per_page: @page_size)

    render status: '200', json: {
      results: @paginated_institutions,
      page: @page,
      totalItems: institutions_count
    }
  end

  def show
    render status: :bad_request, json: { message: 'id must be present' } and return if @institution_id.nil?

    institution = Institution.find_by(id: @institution_id)
    render status: :bad_request, json: { message: 'school does not exists' } and return if institution.nil?

    render status: '200', json: institution.to_json(include: {subject_sets: {include: [:subjects, :subject_set_requirements_info]}})
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

  def class_profiles
    @class_profiles = params.fetch(:class_profiles, nil)
    @class_profiles = @class_profiles.strip.split(",") if @class_profiles.nil? == false
  end

  def sports
    @sports = params.fetch(:sports, nil)
    @sports = @sports.gsub(',', ' ') if @sports.nil? == false
  end

  def foreign_languages
    @foreign_languages = params.fetch(:foreign_languages, nil)
    @foreign_languages = @foreign_languages.gsub(',', ' ') if @foreign_languages.nil? == false
  end

  def extracurricular_activities
    @extracurricular_activities = params.fetch(:extracurricular_activities, nil)
    if @extracurricular_activities.nil? == false
      @extracurricular_activities = @extracurricular_activities.gsub(',', ' ')
    end
  end
end
