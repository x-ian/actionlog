class EventArea < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "meeting_id"

  belongs_to :meeting
  has_many :events
end
