class AddAccountIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :account_id, :integer
    add_column :users, :pw, :string
    add_column :users, :login, :string
  end

  def self.down
    remove_column :users, :account_id
    remove_column :users, :pw
    remove_column :users, :login
  end
end
