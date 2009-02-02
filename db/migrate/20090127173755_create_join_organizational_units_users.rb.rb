class CreateJoinOrganizationalUnitsUsers < ActiveRecord::Migration
  def self.up
    create_table :organizational_units_users, :id => false do |t|
      t.integer :organizational_unit_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :organizational_units_users
  end
end
