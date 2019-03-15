class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.text :access_uuid
      t.references :volunteer, foreign_key: true
      t.references :prefered_role, foreign_key: true
      t.references :meeting, foreign_key: true
      t.text :content
      t.boolean :opened
      t.boolean :took_role

      t.timestamps
    end
    add_index :requests, :access_uuid, unique: true
  end
end
