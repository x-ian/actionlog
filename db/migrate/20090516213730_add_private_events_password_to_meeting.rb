class AddPrivateEventsPasswordToMeeting < ActiveRecord::Migration
  def self.up
    add_column :meetings, :private_events_password, :string
  end

  def self.down
    remove_column :meetings, :private_events_password
  end
end
