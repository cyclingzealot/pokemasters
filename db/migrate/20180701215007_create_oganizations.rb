class CreateOganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations do |t|
      t.text :name, null: false
      t.text :email
      t.text :web
      t.boolean :enabled, default: true, null: false

      t.timestamps
    end

    o = Organization.new(name: 'Carleton Toastmasters', web: 'http://www.carletontm.ca', enabled: true)
    o.save!
  end
end
