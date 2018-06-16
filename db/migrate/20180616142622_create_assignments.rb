class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.references :volunteer, foreign_key: true, null: false
      t.references :meeting, foreign_key: true, null: false
      t.references :role, foreign_key: true, null: false
      t.boolean :mia

      t.timestamps
    end
  end
end
