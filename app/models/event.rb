class Event < ActiveRecord::Base
  PASSWORD_PROTECTED_NAME = "(confidential events are not visible)"

  before_save :update_timestamp

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "event_area_id"
  validates_presence_of :event_area
  
  belongs_to :event_area
  belongs_to :escalated_meeting, :class_name => "Meeting"

  has_many :aktions, :dependent => :destroy
  has_many :customized_values, :dependent => :destroy

  belongs_to :user
  belongs_to :event_type
  belongs_to :priority, :dependent => :destroy

  def update_timestamp
    write_attribute :log_date, Time.now.to_date
  end

  def self.new_with_defaults(meeting)
    e = Event.new
    e.user_id = meeting.responsible_user_id unless meeting == nil || meeting.responsible_user.blank?
    e.meeting_date = Time.now.to_date
    e.event_type_id = EventType::ISSUE
    e.event_area = EventArea.find_by_meeting_id(meeting)
    return e
  end

  # BEGIN possible mixin or whatever for aktion and event
  def default_meeting=(v)
    @default_meeting = v
  end

  def meeting_id
    return event_area.meeting_id unless event_area.nil?
    return @default_meeting.id if event_area.nil? && @default_meeting != nil
  end

  def meeting
    return event_area.meeting unless event_area.nil?
    return @default_meeting if event_area.nil? && @default_meeting != nil
  end

  def meeting_id=(value)
  end
  
  def organizational_unit_id
    return event_area.meeting.organizational_unit_id unless event_area.nil? || event_area.meeting.nil?
    return @default_meeting.organizational_unit_id if (event_area.nil? || event_area.meeting.nil?) && @default_meeting != nil && @default_meeting.organizational_unit != nil
  end

  def organizational_unit
    return event_area.meeting.organizational_unit unless event_area.nil? || event_area.meeting.nil?
    return @default_meeting.organizational_unit if (event_area.nil? || event_area.meeting.nil?) && @default_meeting != nil && @default_meeting.organizational_unit != nil
  end
  # END possible mixin or whatever for aktion and event

  def customized_schemas
    CustomizedSchema.find_all_customized_schemas(organizational_unit, CustomizedFieldType::EVENT)
  end

  def customized_value(schema)
    CustomizedValue.find(:first, :conditions => [ "event_id = ? AND customized_schema_id = ?", id, schema.id])
  end

  def assign_customized_values(values)
    customized_values.each do |item|
      item.destroy
    end

    values.each do |key,value|
      unless value.empty?
        cv = CustomizedValue.new
        cv.event = self
        cs_id = key["customized_schema_".length, key.length - "customized_schema_".length]
        cv.customized_schema_id = cs_id
        cv.value = value
        cv.save
        customized_values << cv
      end
    end
  end

  def assign_priorities(priorities, description)
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
    p.description = description
    p.save
    priority = p
  end

  def priority_value_by_axis(axis_id)
    priority.priority_ranges.detect { |v| v.priority_axis_id == axis_id } unless priority == nil 
  end

  def self.find_all_by_filter_form(params, meeting)
    e = []
    a = Aktion.find_all_by_filter_form(params, meeting)
    a.each { |item| 
      if e.index(item.event) == nil
        e.insert(-1, item.event) if params[:action_status].blank?
        e.insert(-1, item.event) if params[:action_status].to_s == item.event.status_by_actions.to_s
      end
    }
    return e
  end

  def self.find_events_without_actions(meeting)
    return [] if meeting == nil

    sql = "SELECT events.* FROM events "
    sql += "LEFT JOIN event_areas ON event_areas.id = event_area_id LEFT JOIN meetings ON meetings.id = event_areas.meeting_id "
    sql += "WHERE events.id NOT IN "
    sql += "(SELECT event_id FROM aktions LEFT JOIN events ON events.id = event_id LEFT JOIN event_areas on event_areas.id = events.event_area_id LEFT JOIN meetings ON meetings.id = event_areas.meeting_id "
    sql += "WHERE (meeting_id = #{meeting.id} OR escalated_meeting_id=#{meeting.id})" unless meeting == "(all)"
    sql += ") "
    sql += "AND (meeting_id = #{meeting.id} OR escalated_meeting_id=#{meeting.id}) " unless meeting == "(all)"
    sql += "ORDER BY meeting_date"
    return Event.find_by_sql(sql)
  end

  def self.find_all_events_of_meeting(meeting)
    return [] if meeting == nil
    Event.find(:all, :joins => [ :event_area ], :conditions => [ "event_areas.meeting_id = ?",  meeting.id])
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
