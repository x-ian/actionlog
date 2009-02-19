class ActionLogQuickAddController < ApplicationController

  def quick_add_action
    aktion = Aktion.new
    aktion.event = Event.find(params[:id])
    render :update do |page|
      page.insert_html :after, params[:insert_after_dom_id], :partial => "action_log_quick_add/index_actions_grouped_by_actions_tr_quick_add", :locals => { :aktion => aktion, :temp_action_id => random_dom_id }
      #page.replace_html params[:insert_after_dom_id], :partial => "inplace_edit_event", :locals => { :aktion => Aktion.find(params[:id]) }
    end
  end

  def add_action
    aktion = Aktion.new
    aktion.event_id = params[:id]
    # defaults for aktion
    aktion.assignment_date = Time.now.to_date

    respond_to do |format|
      if aktion.update_attributes(params[:aktion])
        flash[:notice] = 'Action was successfully updated.'
      else
        flash[:error] = 'Error while updating action.'
      end
      format.js {
        render :update do |page|
          page.insert_html :after, "action-#{params[:temp_action_id]}", :partial => "index_actions_grouped_by_actions_tr", :locals => { :aktion => aktion }
          highlight_changed_row page, aktion
          page.remove "action-#{params[:temp_action_id]}"
        end
      }
    end
  end

  def cancel_add_action
    render :update do |page|
      page.remove "action-#{params[:temp_action_id]}"
    end
  end

  def quick_add_event_and_action
    aktion = Aktion.new
    render :update do |page|
      page.insert_html :after, params[:insert_after_dom_id], :partial => "action_log_quick_add/index_actions_grouped_by_actions_tr_quick_add_event_and_action", :locals => { :aktion => aktion, :temp_action_id => random_dom_id }
    end
  end

  def add_event_and_action
    if params[:event_id].blank?
      event = Event.new
      # defaults for event
      event.meeting_date = Time.now.to_date
      event.event_type_id = EventType::ISSUE
      event.name = params[:event_name]
      event.event_area = EventArea.find_by_meeting_id(current_meeting)
      event.save
    else
      event = Event.find(params[:event_id])
    end

    aktion = Aktion.new
    aktion.event_id = event.id
    # defaults for aktion
    aktion.assignment_date = Time.now.to_date

    respond_to do |format|
      if aktion.update_attributes(params[:aktion])
        flash[:notice] = 'Action was successfully updated.'
      else
        flash[:error] = 'Error while updating action.'
      end
      format.js {
        render :update do |page|
          page.insert_html :after, "action-#{params[:temp_action_id]}", :partial => "index_actions_grouped_by_actions_tr", :locals => { :aktion => aktion }
          highlight_changed_row page, aktion
          page.remove "action-#{params[:temp_action_id]}"
        end
      }
    end
  end

  def cancel_add_event_and_action
    render :update do |page|
      page.remove "action-#{params[:temp_action_id]}"
    end
  end

  def fill_event_select_for_action
    render :partial => "event_select", :locals => { :event_area_id => params[:id], :aktion => nil, :dom_id => random_dom_id }
  end

end
