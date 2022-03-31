class AddNewFieldsFromGdyniaToInstitutions < ActiveRecord::Migration[7.0]
  def change
    add_column :institutions, :description, :string
    add_column :institutions, :sports, :string
    add_column :institutions, :foreign_languages, :string
    add_column :institutions, :class_profiles, :string
    add_column :institutions, :extracurricular_activities, :string
  end
end
