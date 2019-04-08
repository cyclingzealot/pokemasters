class AddOrganizationToRole < ActiveRecord::Migration[5.1]
  def change
    if ActiveRecord::Base.connection.instance_values["config"][:adapter] == "sqlite3"
        add_reference :roles, :organization, null: false, index: true, default: 1
    else
        add_reference :roles, :organization, null: false, index:true
    end
  end
end
