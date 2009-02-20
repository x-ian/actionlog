class CreateMinutes < ActiveRecord::Migration
  def self.up
    create_table :minutes do |t|
      t.text :name
      t.integer :event_area_id
      t.integer :user_id
      t.date :meeting_date

      t.timestamps
    end
  end

  def self.down
    drop_table :minutes
  end
end
