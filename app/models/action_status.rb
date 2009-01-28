class ActionStatus < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :aktions

  UNCOMPLETED = ActionStatus.find(1).id
  COMPLETED = ActionStatus.find(2).id
  NO_LONGER_RELEVANT = ActionStatus.find(3).id
  DELETED = ActionStatus.find(4).id
end
