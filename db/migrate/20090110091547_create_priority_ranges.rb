class CreatePriorityRanges < ActiveRecord::Migration
  def self.up
    create_table :priority_ranges do |t|
      t.string :value
      t.text :description
      t.integer :priority_axis_id

      t.timestamps
    end
  end

  def self.down
    drop_table :priority_ranges
  end
end
