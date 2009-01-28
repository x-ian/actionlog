class CreateEventAreas < ActiveRecord::Migration
  def self.up
    create_table :event_areas do |t|
      t.string :name
      t.integer :meeting_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :event_areas
  end
end
