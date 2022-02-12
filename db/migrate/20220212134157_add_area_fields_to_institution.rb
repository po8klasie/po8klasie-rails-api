class AddAreaFieldsToInstitution < ActiveRecord::Migration[7.0]
  def change
    add_column :institutions, :powiat, :string, null: false
    add_column :institutions, :gmina, :string, null: false
    add_column :institutions, :miejscowosc, :string, null: false
  end
end
