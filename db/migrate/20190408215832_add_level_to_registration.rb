class AddLevelToRegistration < ActiveRecord::Migration[5.1]
  def change
    add_column :registrations, :start_level, :integer, default: nil
  end
end
