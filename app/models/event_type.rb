class EventType < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :events

  ISSUE = EventType.exists?(1) ? EventType.find(1).id : nil
  VARIANCE = EventType.exists?(2) ? EventType.find(2).id : nil
  RISK = EventType.exists?(3) ? EventType.find(3).id : nil

end
