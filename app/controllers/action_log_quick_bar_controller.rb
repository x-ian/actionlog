class ActionLogQuickBarController < ApplicationController

  before_filter :login_required

  protect_from_forgery :except => :update_meeting_summary

  def update_meeting_summary
    s = create_meeting_summary
    render :partial => "action_log_quick_bar/meeting_summary_content", :locals => { :meeting_summary => s}
  end
end
