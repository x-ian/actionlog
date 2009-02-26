class DailyDigestDashboardController < ApplicationController

  before_filter :login_required
  after_filter :reset_readonly_flag

  def reset_readonly_flag
    @readonly = false
  end
  
  def index
    @readonly = true
    # reset grouped by view
    session[:action_log_current_view] = nil
    set_current_meeting(Meeting.find(params[:meeting_id])) unless params[:meeting_id].blank?
    
    @minutes = Minute.find_latest_minutes_of_meeting(current_meeting)
    @requested_actions = Aktion.find_all_by_filter_form({ :action_status => ActionStatus::UNCOMPLETED, :requested => current_user.id}, current_meeting)
    @responsible_actions = Aktion.find_all_by_filter_form({ :action_status => ActionStatus::UNCOMPLETED, :responsible => current_user.id}, current_meeting)
  end

  def notify_participants
    mails_sent = 0
    for user in current_meeting.users
      unless user.email.blank?
        Notifications.deliver_daily_digest_dashboard(user, current_meeting, controller_url, create_meeting_summary)
        mails_sent=+1
      end
    end

    respond_to do |format|
      flash[:info] = "Notification sent to #{help.pluralize(mails_sent, 'participant')}"
      format.html { redirect_to(:action => "index") }
    end
  end

  def controller_url
    "http://" + server_address + "/daily_digest_dashboard"
  end

end
