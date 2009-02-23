class DailyDigestDashboardController < ApplicationController
  after_filter :reset_readonly_flag

  def reset_readonly_flag
    @readonly = false
  end
  
  def index
    @readonly = true
    # reset grouped by view
    session[:action_log_current_view] = nil
    
    @minutes = Minute.find_latest_minutes_of_meeting(current_meeting)
    @requested_actions = Aktion.find_all_by_filter_form({ :action_status => ActionStatus::UNCOMPLETED, :requested => current_user.id}, current_meeting)
    @responsible_actions = Aktion.find_all_by_filter_form({ :action_status => ActionStatus::UNCOMPLETED, :responsible => current_user.id}, current_meeting)
  end
end
