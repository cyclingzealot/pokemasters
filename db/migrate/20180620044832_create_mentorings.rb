class CreateMentorings < ActiveRecord::Migration[5.1]
  def change
    create_table :mentorings do |t|
      t.references :volunteer, foreign_key: true, null: false, index: {name: 'mentor'}
      t.references :volunteer, foreign_key: true, null: false, index: {name: 'mentee'}

      t.timestamps
    end
  end
end
