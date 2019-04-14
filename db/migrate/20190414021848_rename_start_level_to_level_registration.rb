class RenameStartLevelToLevelRegistration < ActiveRecord::Migration[5.1]
  def change
    rename_column :registrations, :start_level, :level
  end
end
