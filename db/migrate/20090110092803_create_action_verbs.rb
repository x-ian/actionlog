class CreateActionVerbs < ActiveRecord::Migration
  def self.up
    create_table :action_verbs do |t|
      t.string :verb
      t.boolean :disliked

      t.timestamps
    end
  end

  def self.down
    drop_table :action_verbs
  end
end
