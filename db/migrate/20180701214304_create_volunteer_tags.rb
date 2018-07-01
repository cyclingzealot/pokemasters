class CreateVolunteerTags < ActiveRecord::Migration[5.1]
  def change
    create_table :volunteer_tags do |t|
      t.text :short_name
      t.string :name_english

      t.timestamps
    end

    vt = VolunteerTag.new(short_name: 'mentor', name_english: 'mentor')
    vt.save!
  end
end
