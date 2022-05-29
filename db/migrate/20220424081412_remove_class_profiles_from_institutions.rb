class RemoveClassProfilesFromInstitutions < ActiveRecord::Migration[7.0]
  def change
    remove_column :institutions, :class_profiles
  end
end
