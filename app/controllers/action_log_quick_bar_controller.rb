class ActionLogQuickBarController < ApplicationController

  before_filter :login_required

  def update_meeting_summary
    begin
      s = create_meeting_summary
      #render :partial => "action_log_quick_bar/meeting_summary_content", :locals => { :meeting_summary => s}
    rescure Exception exc
      # nop
    else
      # nop
    end
  end
end
