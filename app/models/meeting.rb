class Meeting < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "organizational_unit_id"
  validates_presence_of :organizational_unit
  #validates_associated :organizational_unit # seems to fail with ActivaScaffold (only in dev?)

  belongs_to :organizational_unit
  has_many :event_areas
#  has_many :users
  has_and_belongs_to_many :users
  #has_many :escalated_meetings, :class_name => "Event"
  belongs_to :responsible_user, :class_name=>"User"

  def invalid?
    organizational_unit.nil? 
  end

  def self.find_all_meetings_of_organizational_units(organizational_units)
    return Meeting.find(:all) if organizational_units == nil || organizational_units.empty?

    m = []
    organizational_units.each{ |organizational_unit|
      logger.debug "#{organizational_unit}"
      if organizational_unit != nil && organizational_unit_id != nil
        m = m | Meeting.find_all_by_organizational_unit_id(organizational_unit.id)
        organizational_unit.all_children.each{ |c|
          m = m | Meeting.find_all_by_organizational_unit_id(c.id)
        }
      end
    }
    return m
  end

  def find_all_meetings_to_escalate_to
    Meeting.find_all_meetings_of_organizational_units([organizational_unit.root])
  end
end
