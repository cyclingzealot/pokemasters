class ChangeMentoring < ActiveRecord::Migration[5.1]
  def change
    remove_reference :mentorings, :volunteers

    add_reference :mentorings, :mentee, index: true
    add_foreign_key :mentorings, :volunteer, column: :mentee_id
    change_column :mentorings, :mentee_id, :integer, null: false

    add_reference :mentorings, :mentor, index: true
    add_foreign_key :mentorings, :volunteer, column: :mentor_id
    change_column :mentorings, :mentor_id, :integer, null: false

  end
end
