class CreateCustomizedValues < ActiveRecord::Migration
  def self.up
    create_table :customized_values do |t|
      t.integer :customized_schema_id
      t.integer :aktion_id
      t.integer :event_id
      t.text :value

      t.timestamps
    end
  end

  def self.down
    drop_table :customized_values
  end
end
