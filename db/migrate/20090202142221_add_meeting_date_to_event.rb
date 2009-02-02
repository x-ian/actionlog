class AddMeetingDateToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :meeting_date, :date
  end

  def self.down
    remove_column :events, :meeting_date
  end
end
