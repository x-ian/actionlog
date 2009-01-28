class AddBetterNestedSetAttributesToOrganizationalUnit < ActiveRecord::Migration
  def self.up
    add_column :organizational_units, :lft, :integer, :null => false
    add_column :organizational_units, :rgt, :integer, :null => false
    add_column :organizational_units, :lock_version, :integer, :default => 0
  end

  def self.down
    remove_column :organizational_units, :lock_version
    remove_column :organizational_units, :rgt
    remove_column :organizational_units, :lft
  end
end
