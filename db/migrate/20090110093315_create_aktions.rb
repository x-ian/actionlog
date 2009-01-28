class CreateAktions < ActiveRecord::Migration
  def self.up
    create_table :aktions do |t|
      t.date :log_date
      t.date :assignment_date
      t.string :action_required
      t.date :review_date
      t.date :target_date
      t.date :new_target_date
      t.boolean :new_target_date_changed
      t.text :closeout_comment
      t.date :actual_completion_date
      t.integer :event_id
      t.integer :requested_by_id
      t.integer :primary_responsible_id
      t.integer :secondary_responsible_id
      t.integer :action_priority_id
      t.integer :action_status_id

      t.timestamps
    end
  end

  def self.down
    drop_table :aktions
  end
end
