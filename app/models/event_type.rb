class EventType < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :events

  ISSUE = EventType.find(1).id
  VARIANCE = EventType.find(2).id
  RISK = EventType.find(3).id

end
