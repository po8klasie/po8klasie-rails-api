class AddExtraFieldsFromGdynia < ActiveRecord::Migration[7.0]
  def change
    #all of these can be null
    add_column :institutions, :integration_classes, :float
    add_column :institutions, :classrooms, :float
    add_column :institutions, :sport_facilities, :float
    add_column :institutions, :working_time, :float
    add_column :institutions, :students_per_teacher, :float
  end
end
