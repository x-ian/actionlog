class AddConstraintsToUser < ActiveRecord::Migration
  def self.up
    change_column :users, :role_id, :integer, :null => false, :default => 1
    change_column :users, :public_user, :boolean, :null => false, :default => false
    change_column :users, :inactive, :boolean, :null => false, :default => false
  end

  def self.down
  end
end
