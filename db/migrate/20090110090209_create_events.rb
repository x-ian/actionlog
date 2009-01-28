class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.date :log_date
      t.integer :event_area_id
      t.integer :escalated_event_area_id
      t.integer :event_type_id
      t.integer :user_id
      t.integer :priority_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
