class Meeting < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "organizational_unit_id"

  belongs_to :organizational_unit
  has_many :event_areas
#  has_many :users
  has_and_belongs_to_many :users

end
