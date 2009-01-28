class CreatePriorityAxes < ActiveRecord::Migration
  def self.up
    create_table :priority_axes do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :priority_axes
  end
end
