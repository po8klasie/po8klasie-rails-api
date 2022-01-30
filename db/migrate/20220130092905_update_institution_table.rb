class UpdateInstitutionTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :institutions, :address 
    add_column :institutions, :city , :string
    add_column :institutions, :street , :string
    add_column :institutions, :building_no , :string
    add_column :institutions, :apartment_no , :string
    add_column :institutions, :zip_code , :string
  end
end
