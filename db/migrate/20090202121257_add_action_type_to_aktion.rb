class AddActionTypeToAktion < ActiveRecord::Migration
  def self.up
    add_column :aktions, :action_type_id, :integer
  end

  def self.down
    remove_column :aktions, :action_type_id
  end
end
