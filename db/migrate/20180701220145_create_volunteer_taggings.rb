class CreateVolunteerTaggings < ActiveRecord::Migration[5.1]
  def change
    create_table :volunteer_taggings do |t|
      t.references :volunteer, foreign_key: true
      t.references :volunteer_tag, foreign_key: true
      t.references :organization, foreign_key: true, default: 1

      t.timestamps
    end

    add_index :volunteer_taggings, [:volunteer_id, :volunteer_tag_id, :organization_id], unique: true, name: 'unique_combo'
  end
end
