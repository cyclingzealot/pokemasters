class ReplaceRankWithLevel < ActiveRecord::Migration[5.1]
  def change
    rename_column :roles, :rank, :level
  end
end
