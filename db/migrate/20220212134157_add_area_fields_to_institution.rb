class AddAreaFieldsToInstitution < ActiveRecord::Migration[7.0]
  def change
    add_column :institutions, :county, :string, null: false
    add_column :institutions, :municipality, :string, null: false
    add_column :institutions, :town, :string, null: false
  end
end
