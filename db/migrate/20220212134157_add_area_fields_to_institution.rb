class AddAreaFieldsToInstitution < ActiveRecord::Migration[7.0]
  def change
<<<<<<< HEAD
    add_column :institutions, :powiat, :string, null: false
    add_column :institutions, :gmina, :string, null: false
    add_column :institutions, :miejscowosc, :string, null: false
=======
    add_column :institutions, :county, :string, null: false
    add_column :institutions, :municipality, :string, null: false
    add_column :institutions, :town, :string, null: false
>>>>>>> 67f01d679c32bb55c0e8c0538db62ba085367644
  end
end
