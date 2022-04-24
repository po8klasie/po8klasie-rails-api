class CreateExtendedSubjectSets < ActiveRecord::Migration[7.0]
  def change
    create_table :subject_sets do |t|
      t.belongs_to :institution
      t.timestamps
    end
  end
end
