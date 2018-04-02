class AddNotNullToVolunteers < ActiveRecord::Migration[5.1]
  def change
    change_column_null :volunteers, :name, false
    change_column_null :volunteers, :email, false
    change_column_null :volunteers, :tie_breaker_uuid, false
    change_column_null :volunteers, :last_synched, false
    change_column_null :volunteers, :is_member, false
    change_column :volunteers, :is_member, :boolean, :default => false
  end
end
