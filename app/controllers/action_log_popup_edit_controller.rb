class ActionLogPopupEditController < ApplicationController

  # Aktion

  def show_popup_edit_action
    aktion = Aktion.find(params[:id])
    render :update do |page|
      page.replace_html "popup_action_action_required", :partial => "action_log_popup_edit/action_action_required", :locals => {:aktion => aktion }
      page.replace_html "popup_action_actual_completion_date_and_status", :partial => "action_log_popup_edit/action_actual_completion_date_and_status", :locals => {:aktion => aktion }
      page.replace_html "popup_action_assignment_date", :partial => "action_log_popup_edit/action_assignment_date", :locals => {:aktion => aktion }
      page.replace_html "popup_action_closeout_comment", :partial => "action_log_popup_edit/action_closeout_comment", :locals => {:aktion => aktion }
      page.replace_html "popup_action_event_area_select", :partial => "action_log_popup_edit/action_event_area_select", :locals => {:aktion => aktion, :meeting_id => aktion.meeting_id }
      page.replace_html "popup_action_event_select", :partial => "action_log_popup_edit/action_event_select", :locals => {:aktion => aktion, :event_area_id => aktion.event_area_id }
      page.replace_html "popup_action_id", :partial => "action_log_popup_edit/action_id", :locals => {:aktion => aktion }
      page.replace_html "popup_action_requested_by", :partial => "action_log_popup_edit/action_requested_by", :locals => {:aktion => aktion }
      page.replace_html "popup_action_responsible", :partial => "action_log_popup_edit/action_responsible", :locals => {:aktion => aktion }
      page.replace_html "popup_action_review_date", :partial => "action_log_popup_edit/action_review_date", :locals => {:aktion => aktion }
      page.replace_html "popup_action_target_date", :partial => "action_log_popup_edit/action_target_date", :locals => {:aktion => aktion }
      if initial_review_date_necessary(aktion)
        page['popup_action_review_date'].show
      else
        page['popup_action_review_date'].hide
      end
      page.replace_html "popup_action_title", :partial => "action_log_popup_edit/action_title", :locals => {:aktion => aktion }
      page.replace_html "popup_action_type_and_priority", :partial => "action_log_popup_edit/action_type_and_priority", :locals => {:aktion => aktion }
      page << "$('edit_action_popup').popup.show();"
    end
  end

  def update_action
    aktion = Aktion.find(params[:id])
    aktion.action_type = ActionType.find_by_name(params["popup_action_type"]) unless params["popup_action_type"].blank?
    aktion.event_id = params[:my_event_id] unless params[:popup_my_event_id].blank?

    respond_to do |format|
      if aktion.update_attributes(params[:aktion])
        flash[:notice] = 'Action was successfully updated.'
      else
        flash[:error] = 'Error while updating action.'
      end
      format.js {
        render :update do |page|
          page << "$('edit_action_popup').popup.hide();"
          page.replace_html "action-#{aktion.id}", :partial => "action_log/index_actions_grouped_by_actions_row", :locals => {:aktion => aktion}
          highlight_changed_row page, aktion
        end
      }
    end
  end

  def fill_event_select_for_action
    render :partial => "action_event_select", :locals => { :event_area_id => params[:id], :aktion => nil }
  end

  def show_secondary_responsible
    render :update do |page|
      page.visual_effect(:blind_down, "popup_action_secondary_responsible") unless params[:id].blank?
      page.visual_effect(:blind_up, "popup_action_secondary_responsible") if params[:id].blank?
    end
  end

  def show_review_date
    render :update do |page|
      review = review_date_necessary(params[:value], Aktion.find(params[:id]))
      page.visual_effect(:blind_down, "popup_action_review_date") if review
      page["popup_aktion_review_date"].value = calc_review_date(params[:id]) if review
      page.visual_effect(:blind_up, "popup_action_review_date") unless review
    end
  end

  def check_action_required
    action_status = "50"

    unless params[:verb].blank?
      if ActionVerb.bad_verb(params[:verb])
        action_status = "5 "
      elsif ActionVerb.good_verb(params[:verb])
        action_status = "100"
      end
    end
    render :update do |page|
      page.call 'popup_action_status_PB.setPercentage', action_status
    end
  end

  # Event

  def show_popup_edit_event
    event = Event.find(params[:id])
    render :update do |page|
      page.replace_html "popup_event_table", :partial => "action_log_popup_edit/event_table", :locals => {:event => event }
      page.replace_html "popup_event_title", :partial => "action_log_popup_edit/event_title", :locals => {:event => event }
      page << "$('edit_event_popup').popup.show();"
    end
  end

  def update_event
    event = Event.find(params[:id])
    event.assign_priorities(collect_priority_values(params))
    event.event_type = EventType.find_by_name(params["popup_event_type"]) unless params["popup_event_type"].blank?

    respond_to do |format|
      if event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
      else
        flash[:error] = 'Error while updating event.'
      end
      format.js {
        render :update do |page|
          page << "$('edit_event_popup').popup.hide();"
          if session[:action_log_current_view] == "grouped_by_events"
            page.replace_html "event-#{event.id}-event", :partial => "action_log/table_cells/event_grouped_by_events", :locals => {:event => event}
            page.visual_effect(:highlight, "event-#{event.id}-event") unless params[:event] == nil
          else
            for aktion in event.aktions
              page.replace_html "action-#{aktion.id}", :partial => "action_log/index_actions_grouped_by_actions_row", :locals => {:aktion => aktion}
              highlight_changed_row page, aktion
            end
          end
        end
      }
    end
  end

  def collect_priority_values(params)
    params.select { |key,value| key.starts_with?("priority_axis_") }
  end
end
