# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '7d3267a83e79ff454c78edf94699b8ad'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  ActiveScaffold.set_defaults do |config|
    config.ignore_columns.add [:created_at, :updated_at, :lock_version]
  end

  # restful_authentication
  include AuthenticatedSystem

  # Exception Notification
  include ExceptionNotifiable
  #local_addresses.clear # always send email notifications instead of displaying the error
  # error testing
  #def error
  #  raise RuntimeError, "Generating an error"
  #end

  def current_user
    return current_account.user if current_account
  end

  def current_meeting
    return session[:current_meeting] unless session[:current_meeting].blank?
    #session[:current_meeting] = current_user.meetings.first unless current_user.meetings.size < 1
  end

  def set_current_meeting(meeting)
    session[:current_meeting] = meeting
  end

  def random_dom_id
    "temp_id_#{rand(64000)}"
  end

  def server_address
    address = request.env["SERVER_NAME"]
    address += ":" + request.env["SERVER_PORT"] unless request.env["SERVER_PORT"] == "80"
    address
  end

  # provide TextHelper methods from Views in Controllers
  # seen under http://snippets.dzone.com/posts/show/1799
  def help
    Helper.instance
  end
  class Helper
    include Singleton
    include ActionView::Helpers::TextHelper
  end

  def create_meeting_summary
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
    return s
  end
end
