class EventType < ActiveRecord::Base
  validates_presence_of :type
  validates_uniqueness_of :type

  has_many :events
end
