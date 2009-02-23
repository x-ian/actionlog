class Minute < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => "event_area_id"
  validates_presence_of :event_area

  belongs_to :event_area
  belongs_to :user

  def self.new_with_defaults
    Minute.new({:meeting_date => Time.now.to_date, :user_id => current_user.id})
  end

  def self.find_all_minutes_of_meeting(meeting)
    return [] if meeting == nil
    Minute.find(:all, :joins => [ :event_area ], :conditions => [ "event_areas.meeting_id = ?",  meeting.id], :order => "minutes.event_area_id")
  end

  def self.find_latest_minutes_of_meeting(meeting)
    return [] if meeting == nil
    latest_meeting_date = Minute.calculate(:max, :meeting_date, :joins => [ :event_area ], :conditions => [ "event_areas.meeting_id = ?",  meeting.id] )
    Minute.find(:all, :joins => [ :event_area ], :conditions => [ "event_areas.meeting_id = ? AND meeting_date = ?",  meeting.id, latest_meeting_date], :order => "minutes.event_area_id")
  end

  def self.find_all_by_filter_form(params, meeting)
    return [] if meeting.nil?
    filter_conditions = self.extract_filter_conditions(params, meeting)
    Minute.find(:all, :conditions => filter_conditions, :include => [ :event_area, :user ], :order => "minutes.event_area_id")
  end

  def self.extract_filter_conditions(params, meeting)
    unassigned_value = "(unassigned)"
    conditions = []

    c = "event_areas.meeting_id = ?"
    conditions.insert(-1, meeting.id)

    c = c + " AND event_area_id= ?" unless params[:event_area].blank?
    conditions.insert(-1, params[:event_area]) unless params[:event_area].blank?

    if !params[:owner].blank?
      c = c + " AND user_id= ?" if params[:owner] != unassigned_value
      conditions.insert(-1, params[:owner]) if params[:owner] != unassigned_value
      c = c + " AND user_id IS NULL" if params[:owner] == unassigned_value
    end

    c = c + " AND meeting_date = ?" unless params[:meeting_date].blank?
    conditions.insert(-1, params[:meeting_date]) unless params[:meeting_date].blank?

    conditions.insert(0, c)

    return conditions
  end

end
