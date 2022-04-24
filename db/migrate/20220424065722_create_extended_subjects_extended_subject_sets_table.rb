class CreateExtendedSubjectsExtendedSubjectSetsTable < ActiveRecord::Migration[7.0]
  def change
    create_table :subject_sets_subjects, id: false do |t|
      t.belongs_to :subject_set
      t.belongs_to :subject
      t.timestamps
    end
  end
end
