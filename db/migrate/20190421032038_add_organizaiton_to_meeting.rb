class AddOrganizaitonToMeeting < ActiveRecord::Migration[5.1]
  def change
    add_reference :meetings, :organization, index: true
  end
end
