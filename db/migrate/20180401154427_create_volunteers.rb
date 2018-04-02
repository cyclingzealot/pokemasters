class CreateVolunteers < ActiveRecord::Migration[5.1]
  def change
    create_table :volunteers do |t|
      t.text :name
      t.text :email
      t.text :cell
      t.text :tie_breaker_uuid
      t.datetime :last_synched
      #t.references :last_request, foreign_key: true
      #t.references :last_assignment, foreign_key: true
      #t.references :chapter, foreign_key: true
      t.date :dont_bug_unitl
      t.boolean :dont_bug_ever
      t.text :dont_bug_ever_because
      t.boolean :is_member
      t.text :external_org_id
      #t.references :next_role, foreign_key: true

      t.timestamps
    end
    add_index :volunteers, :external_org_id, unique: true
    add_index :volunteers, :cell, unique: true
    add_index :volunteers, :tie_breaker_uuid, unique: true
  end
end
