class AddPrivateEventToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :private_event, :boolean
  end

  def self.down
    remove_column :events, :private_event
  end
end
