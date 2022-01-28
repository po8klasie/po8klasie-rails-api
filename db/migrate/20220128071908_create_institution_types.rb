class CreateInstitutionTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :institution_types do |t|
      t.string :name 
      t.integer :rspo_institution_type_id
      t.timestamps
    end

    create_table :institutions do |t|
      t.belongs_to :institution_type
      t.integer :rspo_institution_id
      t.string :name
      t.boolean :public 
      t.decimal :latitude, :precision=>10, :scale=>6
      t.decimal :longitude, :precision=>10, :scale=>6
      t.string :website 
      t.string :email
      t.string :address  
      t.timestamps
    end
  end
end
