class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.text :short_name
      t.text :human_name
      t.boolean :is_critical
      t.text :description_blurb
      t.text :instructions_blurb
      t.text :better_role_blurb
      t.text :equipement_blurb
      t.integer :rank

      t.timestamps
    end
    add_index :roles, :short_name, unique: true
    add_index :roles, :human_name, unique: true
  end
end
