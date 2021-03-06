class ActionLogPopupEditController < ApplicationController

  before_filter :login_required

  # Aktion

  def show_popup_add_action
    aktion = Aktion.new
    aktion.event = Event.find(params[:id])
    aktion.requested_by_id = current_user.id
    aktion.primary_responsible_id = current_user.id
    aktion.assignment_date = Time.now.to_date
    
    render :update do |page|
      toggle_select_boxes_for_popups page
      page.replace_html "popup_action_action_required", :partial => "action_log_popup_edit/action_action_required", :locals => {:aktion => aktion }
      page.replace_html "popup_action_actual_completion_date_and_status", :partial => "action_log_popup_edit/action_actual_completion_date_and_status", :locals => {:aktion => aktion }
      page.replace_html "popup_action_assignment_date", :partial => "action_log_popup_edit/action_assignment_date", :locals => {:aktion => aktion }
      page.replace_html "popup_action_closeout_comment", :partial => "action_log_popup_edit/action_closeout_comment", :locals => {:aktion => aktion }
      aktion.customized_schemas.each do |cs|
        page.replace_html "popup_action_customized_value_#{cs.id}", :partial => "action_log_popup_edit/action_customized_values", :locals => {:aktion => aktion, :schema => cs }
      end
      page.replace_html "popup_action_event_area_select", :partial => "action_log_popup_edit/action_event_area_select", :locals => {:aktion => aktion, :meeting_id => aktion.meeting_id }
      page.replace_html "popup_action_event_select", :partial => "action_log_popup_edit/action_event_select", :locals => {:aktion => aktion, :event_area_id => aktion.event_area_id }
      if params[:remove_dom_id]
        page.replace_html "popup_action_id", :partial => "action_log_popup_edit/action_id_add", :locals => {:aktion => aktion, :insert_after_dom_id => params[:insert_after_dom_id], :remove_dom_id => params[:remove_dom_id]}
      else
        page.replace_html "popup_action_id", :partial => "action_log_popup_edit/action_id_add", :locals => {:aktion => aktion, :insert_after_dom_id => params[:insert_after_dom_id], :remove_dom_id => nil }
      end
      page.replace_html "popup_action_requested_by", :partial => "action_log_popup_edit/action_requested_by", :locals => {:aktion => aktion }
      page.replace_html "popup_action_responsible", :partial => "action_log_popup_edit/action_responsible", :locals => {:aktion => aktion }
      page.replace_html "popup_action_review_date", :partial => "action_log_popup_edit/action_review_date", :locals => {:aktion => aktion }
      page.replace_html "popup_action_target_date", :partial => "action_log_popup_edit/action_target_date", :locals => {:aktion => aktion }
      page['popup_action_review_date'].hide
      page.replace_html "popup_action_title", :partial => "action_log_popup_edit/action_title_add", :locals => {:aktion => aktion }
      page.replace_html "popup_action_type_and_priority", :partial => "action_log_popup_edit/action_type_and_priority", :locals => {:aktion => aktion }
      page << "$('edit_action_popup').popup.show();"
    end
  end


  def show_popup_edit_action
    aktion = Aktion.find(params[:id])
    render :update do |page|
      toggle_select_boxes_for_popups page
      page.replace_html "popup_action_action_required", :partial => "action_log_popup_edit/action_action_required", :locals => {:aktion => aktion }
      page.replace_html "popup_action_actual_completion_date_and_status", :partial => "action_log_popup_edit/action_actual_completion_date_and_status", :locals => {:aktion => aktion }
      page.replace_html "popup_action_assignment_date", :partial => "action_log_popup_edit/action_assignment_date", :locals => {:aktion => aktion }
      page.replace_html "popup_action_closeout_comment", :partial => "action_log_popup_edit/action_closeout_comment", :locals => {:aktion => aktion }
      aktion.customized_schemas.each do |cs|
        page.replace_html "popup_action_customized_value_#{cs.id}", :partial => "action_log_popup_edit/action_customized_values", :locals => {:aktion => aktion, :schema => cs }
      end
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
    if params[:aktion]=="cancel"
      render :update do |page|
        toggle_select_boxes_for_popups page
        page << "$('edit_action_popup').popup.hide();"
      end
      return
    end
    add_mode = params[:id].blank?

    aktion = Aktion.new if add_mode
    aktion = Aktion.find(params[:id]) unless add_mode

    aktion.action_type = ActionType.find_by_name(params["popup_action_type"]) unless params["popup_action_type"].blank?
    aktion.event_id = params[:my_event_id] unless params[:popup_my_event_id].blank?
    
    respond_to do |format|
      if aktion.update_attributes(params[:aktion])
        aktion.assign_customized_values(collect_customized_values(params))
        flash[:notice] = 'Action was successfully updated.'
      else
        flash[:error] = 'Error while updating action.'
      end
      format.js {
        render :update do |page|
          toggle_select_boxes_for_popups page
          page << "$('edit_action_popup').popup.hide();"
          if add_mode
            page.insert_html :after, params[:insert_after_dom_id], :partial => "index_actions_grouped_by_actions_tr", :locals => { :aktion => aktion, :add_mode => add_mode }
            page.remove params[:remove_dom_id] unless params[:remove_dom_id].blank?
            page.visual_effect(:blind_up, "index_events_without_actions") if Event.find_events_without_actions(current_meeting).empty?
          else
            page.replace_html "action-#{aktion.id}", :partial => "action_log/index_actions_grouped_by_actions_row", :locals => {:aktion => aktion, :add_mode => add_mode }
            page["action-#{aktion.id}"].remove_class_name "highlighted-record"
            page["action-#{aktion.id}"].remove_class_name "deleted-record"
            page["action-#{aktion.id}"].toggle_class_name get_new_table_row_class(aktion, add_mode)
          end
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
    from_events_without_actions = params[:from_events_without_actions].blank? ? :false : params[:from_events_without_actions]

    render :update do |page|
      page.replace_html "popup_event_table", :partial => "action_log_popup_edit/event_table", :locals => {:event => event, :from_events_without_actions => from_events_without_actions }
      toggle_select_boxes_for_popups page
      page.replace_html "popup_event_title", :partial => "action_log_popup_edit/event_title", :locals => {:event => event }
      if event.event_type_id == 3 # Risk
        page['popup_risk_management_header'].show
        page['popup_risk_management'].show
      else
        page['popup_risk_management_header'].hide
        page['popup_risk_management'].hide
      end
      page << "$('edit_event_popup').popup.show();"
    end
  end

  def update_event
    if params[:aktion]=="cancel"
      render :update do |page|
        toggle_select_boxes_for_popups page
        page << "$('edit_event_popup').popup.hide();"
      end
      return
    end
    event = Event.find(params[:id])
    event.private_event=false #defaulting for stupido checkboxes
    event.assign_priorities(collect_priority_values(params), params[:priority_description])
    event.event_type = EventType.find_by_name(params["popup_event_type"]) unless params["popup_event_type"].blank?
    event.assign_customized_values(collect_customized_values(params))

    respond_to do |format|
      if event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
      else
        flash[:error] = 'Error while updating event.'
      end
      format.js {
        render :update do |page|
          toggle_select_boxes_for_popups page
          page << "$('edit_event_popup').popup.hide();"
          if params[:from_events_without_actions] == "true"
            if !private_events_for?(current_meeting) && event.private_event
              page.replace_html "event-without-action-#{event.id}", :partial => "action_log/index_events_without_actions_tr_confidential", :locals => {:event => event}
            else
              page.replace_html "event-without-action-#{event.id}", :partial => "action_log/index_events_without_actions_tr", :locals => {:event => event}
            end
            page.visual_effect(:highlight, "event-without-action-#{event.id}-area")
            page.visual_effect(:highlight, "event-without-action-#{event.id}-meeting")
            page.visual_effect(:highlight, "event-without-action-#{event.id}-name")
            page.visual_effect(:highlight, "event-without-action-#{event.id}-owner")
            page.visual_effect(:highlight, "event-without-action-#{event.id}-actions")
          elsif session[:action_log_current_view] == "grouped_by_events"
            if !private_events_for?(current_meeting) && event.private_event
              page.reload
            else
              page.replace_html "event-#{event.id}-event", :partial => "action_log/table_cells/event_grouped_by_events", :locals => {:event => event}
              page.visual_effect(:highlight, "event-#{event.id}-event") unless params[:event] == nil
            end
          else
            for aktion in event.aktions
              page << "if ($('action-#{aktion.id}')) {"
              if !private_events_for?(current_meeting) && event.private_event
                page.replace_html "action-#{aktion.id}", :partial => "action_log/index_actions_grouped_by_actions_row_confidential.html", :locals => {:aktion => aktion}
                page.visual_effect(:highlight, "action-#{aktion.id}-event")
              else
                page.replace_html "action-#{aktion.id}", :partial => "action_log/index_actions_grouped_by_actions_row", :locals => {:aktion => aktion}
                highlight_changed_row page, aktion
              end
              page << "}"
            end
          end
        end
      }
    end
  end

  def private_events_for?(meeting)
    !(session["show_private_events_#{meeting.id}"].blank? || session["show_private_events_#{meeting.id}"] == false)
  end

  def collect_customized_values(params)
    params.select { |key,value| key.starts_with?("customized_schema_") }
  end

  def collect_priority_values(params)
    params.select { |key,value| key.starts_with?("priority_axis_") }
  end
end
