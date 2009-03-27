class AddPublicUserToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :public_user, :boolean
  end

  def self.down
    remove_column :users, :public_user
  end
end
