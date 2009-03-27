class AddActivationToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :activation_code, :string, :limit => 40
    add_column :accounts, :activated_at, :datetime
    add_column :accounts, :state, :string, :null => :no, :default => 'passive'
    add_column :accounts, :deleted_at, :datetime
  end

  def self.down
    remove_column :accounts, :deleted_at
    remove_column :accounts, :state
    remove_column :accounts, :activated_at
    remove_column :accounts, :activation_code
  end
end
