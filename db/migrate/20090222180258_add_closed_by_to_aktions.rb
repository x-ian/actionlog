class AddClosedByToAktions < ActiveRecord::Migration
  def self.up
    add_column :aktions, :closed_by_id, :integer
  end

  def self.down
    remove_column :aktions, :closed_by_id
  end
end
