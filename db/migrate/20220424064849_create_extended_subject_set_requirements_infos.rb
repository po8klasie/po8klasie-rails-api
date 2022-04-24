class CreateExtendedSubjectSetRequirementsInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :subject_set_requirements_infos do |t|
      t.belongs_to :subject_set
      t.float :min_points 
      t.float :max_points 
      t.float :average_points
      t.timestamps
    end
  end
end
