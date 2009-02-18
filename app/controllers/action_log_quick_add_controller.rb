class ActionLogQuickAddController < ApplicationController

  def quick_add_action
    aktion = Aktion.new
    aktion.event = Event.find(params[:id])
    render :update do |page|
      page.insert_html :after, params[:current_dom_id], :partial => "action_log_quick_add/index_actions_grouped_by_actions_tr_quick_add", :locals => { :aktion => aktion, :temp_action_id => 9999 }
      #page.replace_html params[:current_dom_id], :partial => "inplace_edit_event", :locals => { :aktion => Aktion.find(params[:id]) }
    end
  end

  def add_action
    aktion = Aktion.new
    aktion.event_id = params[:id]

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

end
