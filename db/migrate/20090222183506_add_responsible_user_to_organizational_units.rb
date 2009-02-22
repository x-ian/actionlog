class AddResponsibleUserToOrganizationalUnits < ActiveRecord::Migration
  def self.up
    add_column :organizational_units, :responsible_user_id, :integer
  end

  def self.down
    remove_column :organizational_units, :responsible_user_id
  end
end
