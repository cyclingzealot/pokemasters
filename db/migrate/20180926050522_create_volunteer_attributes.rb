class CreateVolunteerAttributes < ActiveRecord::Migration[5.1]
  def change
    create_table :volunteer_attributes do |t|
      t.references :volunteer, null: false
      t.references :organization, null: false
      t.boolean :mentor, default: false

      t.timestamps
    end
  end
end
