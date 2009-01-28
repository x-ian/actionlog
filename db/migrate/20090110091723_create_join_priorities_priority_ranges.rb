class CreateJoinPrioritiesPriorityRanges < ActiveRecord::Migration
  def self.up
    create_table :priorities_priority_ranges, :id => false do |t|
      t.integer :priority_id
      t.integer :priority_range_id
    end
  end

  def self.down
    drop_table :priorities_priority_ranges
  end
end
