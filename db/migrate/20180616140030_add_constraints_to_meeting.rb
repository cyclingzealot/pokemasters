class AddConstraintsToMeeting < ActiveRecord::Migration[5.1]
  def change
    change_column_null :meetings, :agenda_uuid, false
  end
end
