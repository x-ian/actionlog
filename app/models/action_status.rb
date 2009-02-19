class ActionStatus < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :aktions

  UNCOMPLETED = 1 #ActionStatus.find(1).id
  COMPLETED = 2 #ActionStatus.find(2).id
  NO_LONGER_RELEVANT = 3 #ActionStatus.find(3).id
  DELETED = 4 #ActionStatus.find(4).id
end
