class CreateActionPriorities < ActiveRecord::Migration
  def self.up
    create_table :action_priorities do |t|
      t.string :level
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :action_priorities
  end
end
