class AddPwToAccount < ActiveRecord::Migration
  def self.up
    add_column :accounts, :pw, :string
  end

  def self.down
    remove_column :accounts, :pw
  end
end
