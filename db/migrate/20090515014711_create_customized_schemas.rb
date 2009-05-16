class CreateCustomizedSchemas < ActiveRecord::Migration
  def self.up
    create_table :customized_schemas do |t|
      t.integer :organizational_unit_id
      t.integer :customized_field_type_id
      t.string :name
      t.string :size
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :customized_schemas
  end
end
