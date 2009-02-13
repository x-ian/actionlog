class Aktion < ActiveRecord::Base
  validates_presence_of :action_required
  validates_uniqueness_of :action_required, :scope => "event_id"
  validates_presence_of :event

  belongs_to :event
  belongs_to :action_priority
  belongs_to :action_status
  belongs_to :action_type

  belongs_to :requested_by, :class_name=>"User"
  belongs_to :primary_responsible, :class_name=>"User"
  belongs_to :secondary_responsible, :class_name=>"User"

  def save
    # timestamp every change
    self.log_date = Time.now.to_date
    # 1st primary responsible, then secondary responsible
    if self.primary_responsible == nil && self.secondary_responsible != nil
      self.primary_responsible_id = self.secondary_responsible_id 
      self.secondary_responsible = nil
    end
    self.action_status_id = ActionStatus::UNCOMPLETED if self.action_status == nil

    self.internal_due_date_for_sorting = Date.civil(9999, 12, 31, Date::ITALY)
    self.internal_due_date_for_sorting = self.target_date unless self.target_date == nil
    self.internal_due_date_for_sorting = self.new_target_date unless self.new_target_date == nil
    self.internal_due_date_for_sorting = self.review_date unless self.review_date == nil
    
    super
  end

  def complete!(closeout_comment)
    self.actual_completion_date = Time.now.to_date
    self.action_status_id = ActionStatus::COMPLETED
    self.closeout_comment = closeout_comment if closeout_comment != nil
    save
  end

  def soft_delete
    self.action_status_id = ActionStatus::DELETED
    save
  end

  def event_area_id
    event.event_area_id unless event.nil?
  end

  def event_area_id=(value)
  end

  def new_target_date=(value)
    if target_date == nil
      self.target_date = value
    else
      if new_target_date != nil # TODO: check if new_target_Date really changed
        self.new_target_date_changed = true
      end
      super
    end
  end

  def overdue
    return false if completed
    if new_target_date != nil && new_target_date <= Time.now.to_date
      return true
    elsif new_target_date == nil && target_date != nil && target_date <= Time.now.to_date
      return true
    end
    return false
  end

  def completed
    return (action_status_id == ActionStatus::COMPLETED || action_status_id == ActionStatus::NO_LONGER_RELEVANT || action_status_id == ActionStatus::DELETED)
    # ???
    #return actual_completion_date != nil && actual_completion_date <= Time.now.to_date
  end

  def check_date_consistency
    # new_target without target
    return false if new_target_date != nil && target_date == nil
    # new_target_date_changed without new_target
    return false if new_target_date_changed && new_target_date == nil
    # review_date without target_date
    return false if review_date != nil && target_date == nil

    # review_date after new_target_date
    return false if review_date >= new_target_date if new_target_date != nil && review_date != nil
    # review_date after target_date
    return false if review_date >= target_date if target_date != nil && new_target_date == nil && review_date != nil

    true
  end

  def self.find_all_by_filter_form(params, meeting, page = 0, per_page = "(all)")
    return [] if meeting.nil?
    filter_conditions = self.extract_filter_conditions(params, meeting)
    if meeting == "(all)"
      if per_page == "(all)"
        Aktion.find(:all, :conditions => filter_conditions, :include => [ :event, :requested_by, :primary_responsible, :secondary_responsible ], :order => "internal_due_date_for_sorting")
      else
        Aktion.paginate(:page => page, :per_page => per_page, :conditions => filter_conditions, :include => [ :event, :requested_by, :primary_responsible, :secondary_responsible ], :order => "internal_due_date_for_sorting")
      end
    else
      joins = "LEFT JOIN events ON events.id = event_id LEFT JOIN event_areas on event_areas.id = events.event_area_id LEFT JOIN meetings ON meetings.id = event_areas.meeting_id"
      if per_page == "(all)"
        Aktion.find(:all, :conditions => filter_conditions, :include => [ :event, :requested_by, :primary_responsible, :secondary_responsible ], :joins => joins, :order => "internal_due_date_for_sorting")
      else
        Aktion.paginate(:page => page, :per_page => per_page, :conditions => filter_conditions, :include => [ :event, :requested_by, :primary_responsible, :secondary_responsible ], :joins => joins, :order => "internal_due_date_for_sorting")
      end
    end
  end

  def self.extract_filter_conditions(params, meeting)
    unassigned_value = "(unassigned)"
    conditions = []
    c = "1 = 1"

    # defaulting
    params[:action_status] = ActionStatus::UNCOMPLETED if params[:action_status] == nil
    
    c = c + " AND action_status_id= ?" unless params[:action_status].blank?
    conditions.insert(-1, params[:action_status]) unless params[:action_status].blank?

    if !params[:requested].blank?
      c = c + " AND requested_by_id= ?" if params[:requested] != unassigned_value
      conditions.insert(-1, params[:requested]) if params[:requested] != unassigned_value
      c = c + " AND requested_by_id IS NULL" if params[:requested] == unassigned_value
    end

    if !params[:responsible].blank?
      c = c + " AND (primary_responsible_id= ? OR secondary_responsible_id= ?)" if params[:responsible] != unassigned_value
      conditions.insert(-1, params[:responsible], params[:responsible]) if params[:responsible] != unassigned_value
      c = c + " AND (primary_responsible_id IS NULL AND secondary_responsible_id IS NULL)" if params[:responsible] == unassigned_value
    end

    unless meeting == "(all)"
      c = c + " AND meetings.id = ?"
      conditions.insert(-1, meeting.id)
    end
    
    c = c + " AND actual_completion_date <= ?" unless params[:to].blank?
    conditions.insert(-1, params[:to]) unless params[:to].blank?
    c = c + " AND actual_completion_date >= ?" unless params[:from].blank?
    conditions.insert(-1, params[:from]) unless params[:from].blank?

    conditions.insert(0, c)

    return conditions
  end

  # BEGIN possible mixin or whatever for aktion and event
  def default_meeting=(v)
    @default_meeting = v
  end

  def meeting_id
    return event.event_area.meeting_id unless event.nil? || event.event_area.nil?
    return @default_meeting.id if (event.nil? || event.event_area.nil?) && @default_meeting != nil
  end

  def meeting
    return event.event_area.meeting unless event.nil? || event.event_area.nil?
    return @default_meeting if (event.nil? || event.event_area.nil?) && @default_meeting != nil
  end

  def meeting_id=(value)
  end

  def organizational_unit_id
    return event.event_area.meeting.organizational_unit_id unless event.nil? || event.event_area.nil? || event.event_area.meeting.nil?
    return @default_meeting.organizational_unit_id if (event.nil? || event.event_area.nil? || event.event_area.meeting.nil?) && @default_meeting != nil && @default_meeting.organizational_unit != nil
  end

  def organizational_unit
    return event.event_area.meeting.organizational_unit unless event.nil? || event.event_area.nil? || event.event_area.meeting.nil?
    return @default_meeting.organizational_unit if (event.nil? || event.event_area.nil? || event.event_area.meeting.nil?) && @default_meeting != nil && @default_meeting.organizational_unit != nil
  end
  # END possible mixin or whatever for aktion and event

end
