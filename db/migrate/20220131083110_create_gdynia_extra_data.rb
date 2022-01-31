class CreateGdyniaExtraData < ActiveRecord::Migration[7.0]
  def change
    create_table :gdynia_extra_data do |t|
      t.timestamps
    end
  end
end
