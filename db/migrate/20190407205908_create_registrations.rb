class CreateRegistrations < ActiveRecord::Migration[5.1]
  def change
    create_table :registrations do |t|
      t.references :volunteer
      t.references :organization

      t.timestamps

    end
    add_index :registrations, [:volunteer_id, :organization_id], unique: true
  end
end
