class ActionPriority < ActiveRecord::Base
  validates_presence_of :level
  validates_uniqueness_of :level

  has_many :aktions
end
