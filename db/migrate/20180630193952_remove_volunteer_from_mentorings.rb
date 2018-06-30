class RemoveVolunteerFromMentorings < ActiveRecord::Migration[5.1]
  def change
    remove_column :mentorings, :volunteer_id
  end
end
