class RspoForeignKey < ActiveRecord::Migration[7.0]
  def change
    add_index :institution_types, [:rspo_institution_type_id], :unique => true
    add_foreign_key :institutions, :institution_types, column: :rspo_institution_id, primary_key: :rspo_institution_type_id
  end
end
