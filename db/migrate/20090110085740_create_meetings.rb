class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.string :name
      t.integer :organizational_unit_id
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :meetings
  end
end
