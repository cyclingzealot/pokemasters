class ChangeDateTimeToDateAndTimeForMeetings < ActiveRecord::Migration[5.1]
  def change
    remove_column :meetings, :date_and_time, :datetime

    add_column :meetings, :date, :date
    add_column :meetings, :time, :time

    Meeting.where(date: nil).update_all(date: Date.new(1970, 1, 1))
    Meeting.where(date: nil).update_all(Time: Time.new("19:00"))

    change_column_null :meetings, :date, false
    change_column_null :meetings, :time, false
  end
end
