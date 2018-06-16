class CreateMeetings < ActiveRecord::Migration[5.1]
  def change
    create_table :meetings do |t|
      t.datetime :date_and_time
      t.text :location
      t.text :agenda_uuid

      t.timestamps
    end
    add_index :meetings, :date_and_time, unique: true
    add_index :meetings, :agenda_uuid, unique: true
  end
end
