class AddConstraintsToRole < ActiveRecord::Migration[5.1]
  def change
    change_column :roles, :is_critical, :boolean, default: false

    change_column_null :roles, :short_name, false
    change_column_null :roles, :human_name, false
    change_column_null :roles, :is_critical, false

  end
end
