class Event < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "event_area_id"
  validates_presence_of :event_area
  
  belongs_to :event_area
  belongs_to :escalated_event_area, :class_name => "EventArea"

  has_many :aktions, :dependent => :destroy

  belongs_to :user
  belongs_to :event_type
  belongs_to :priority, :dependent => :destroy

  def meeting_id
    event_area.meeting_id unless event_area.nil?
  end

  def meeting_id=(value)
  end
  
  def organizational_unit_id
    event_area.meeting.organizational_unit_id unless event_area.nil? || event_area.meeting.nil?
  end

  def organizational_unit
    event_area.meeting.organizational_unit unless event_area.nil? || event_area.meeting.nil?
  end

  def assign_priorities(priorities)
    priority.destroy unless priority.nil?
    p = Priority.new
    p.event = self

    level = ""
    priorities.each do |key,value|
      unless value.empty?
        pa_id = key["priority_axis_".length, key.length - "priority_axis_".length]
        pr = PriorityRange.find_by_priority_axis_id_and_value(pa_id, value)
        p.priority_ranges << pr
        level += value
      end
    end
    p.level = level

    p.save    
    priority = p
  end

  def priority_value_by_axis(axis_id)
    priority.priority_ranges.detect { |v| v.priority_axis_id == axis_id } unless priority == nil 
  end

  def self.find_all_by_filter_form(params)
    e = []
    a = Aktion.find_all_by_filter_form(params)
    a.each { |item| 
      if e.index(item.event) == nil
        e.insert(-1, item.event) if params[:action_status].blank?
        e.insert(-1, item.event) if params[:action_status].to_s == item.event.status_by_actions.to_s
      end
    }
    return e
  end
  
  def status_by_actions
    completed_counter = 0
    no_longer_relevant_counter = 0
    deleted_counter = 0
    aktions.each { |a|
      return ActionStatus::UNCOMPLETED if a.action_status_id == ActionStatus::UNCOMPLETED
      completed_counter += 1 if a.action_status_id == ActionStatus::COMPLETED
      no_longer_relevant_counter += 1 if a.action_status_id == ActionStatus::NO_LONGER_RELEVANT
      deleted_counter += 1 if a.action_status_id == ActionStatus::DELETED
    }
    return ActionStatus::DELETED if deleted_counter == aktions.size
    return ActionStatus::NO_LONGER_RELEVANT if no_longer_relevant_counter == aktions.size
    return ActionStatus::COMPLETED
  end
 
end
