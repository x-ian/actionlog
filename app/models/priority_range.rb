class PriorityRange < ActiveRecord::Base
  validates_presence_of :value
  validates_uniqueness_of :value, :scope => "priority_axis_id"

  has_and_belongs_to_many :priorities
  belongs_to :priority_axis

  def to_label
    "#{value}"
  end
end
