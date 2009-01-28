class Priority < ActiveRecord::Base
  has_one :event
  has_and_belongs_to_many :priority_ranges
end
