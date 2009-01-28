class AddInternalDueDateForSortingToAktion < ActiveRecord::Migration
  def self.up
    add_column :aktions, :internal_due_date_for_sorting, :date
  end

  def self.down
    remove_column :aktions, :internal_due_date_for_sorting
  end
end
