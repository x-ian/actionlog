class AddEscalatedMeetingToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :escalated_meeting_id, :integer
    remove_column :events, :escalated_event_area_id
  end

  def self.down
    remove_column :events, :escalated_meeting_id
    add_column :events, :escalated_event_area_id, :integer
  end
end
