class ActionLogQuickBarController < ApplicationController

  before_filter :login_required

  def update_meeting_summary
    sql = "SELECT DISTINCT COUNT(aktions.id) FROM aktions, events, event_areas "
    sql += "WHERE event_id = events.id AND events.event_area_id = event_areas.id AND (event_areas.meeting_id=#{current_meeting.id} OR events.escalated_meeting_id=#{current_meeting.id})"
    s = ValueObjectMeetingSummary.new

    # all completed actions of current meeting
    s.completed_actions = Aktion.count_by_sql sql + " AND action_status_id=#{ActionStatus::COMPLETED}"
    # all completed actions of current meeting and actual_completion_date = today
    s.completed_actions_today = Aktion.count_by_sql sql + " AND action_status_id=#{ActionStatus::COMPLETED} AND actual_completion_date='#{Time.now.to_date}'"
    # all completed actions of current meeting by current_user
    s.completed_actions_by_user = Aktion.count_by_sql sql + " AND action_status_id=#{ActionStatus::COMPLETED} AND closed_by_id=#{current_user.id}"
    # all uncompleted actions of current meeting
    s.uncompleted_actions = Aktion.count_by_sql sql + " AND action_status_id=#{ActionStatus::UNCOMPLETED}"

    render :partial => "action_log_quick_bar/meeting_summary_content", :locals => { :meeting_summary => s}
  end
end
