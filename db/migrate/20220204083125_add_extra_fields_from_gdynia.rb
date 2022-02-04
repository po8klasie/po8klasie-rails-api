class AddExtraFieldsFromGdynia < ActiveRecord::Migration[7.0]
  def change
    #all of these can be null
    add_column :institutions, :integration_classes, :integer
    add_column :institutions, :classrooms, :integer
    add_column :institutions, :sport_facilities, :integer
    add_column :institutions, :working_time, :integer
    add_column :institutions, :students_per_teacher, :integer
  end
end
