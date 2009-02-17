class ActionLogInplaceEditController < ApplicationController

  def inplace_edit_event_grouped_by_events
    render :partial => "inplace_edit_event_grouped_by_events", :locals => { :event => Event.find(params[:id]) }
  end

  def update_event_grouped_by_events
    event = Event.find(params[:id])
    unless params[:event] == nil
      event.name = params[:event]
      event.save
    end
    render :update do |page|
      page.replace_html "event-#{event.id}-event", :partial => "action_log/table_cells/event_grouped_by_events", :locals => {:event => event}
      page.visual_effect(:highlight, "event-#{event.id}-event") unless params[:event] == nil
    end
  end

  def inplace_edit_event
    render :partial => "inplace_edit_event", :locals => { :aktion => Aktion.find(params[:id]) }
  end

  def update_event
    aktion = Aktion.find(params[:id])
    unless params[:event] == nil
      aktion.event.name = params[:event]
      aktion.event.save
    end
    render :update do |page|
      for a in aktion.event.aktions
        page.replace_html "action-#{a.id}-event", :partial => "action_log/table_cells/event", :locals => {:aktion => a}
        page.visual_effect(:highlight, "action-#{a.id}-event") unless params[:event] == nil
      end
    end
  end

  def inplace_edit_action_required
    render :partial => "inplace_edit_action_required", :locals => { :aktion => Aktion.find(params[:id]) }
  end

  def update_action_required
    a = Aktion.find(params[:id])
    unless params[:action_required] == nil
      a.action_required = params[:action_required]
      a.save
    end
    render :update do |page|
      page.replace_html "action-#{a.id}-action_required", :partial => "action_log/table_cells/action_required", :locals => {:aktion => a}
      page.visual_effect(:highlight, "action-#{a.id}-action_required") unless params[:action_required] == nil
    end
  end

  def inplace_edit_requested_by
    render :partial => "inplace_edit_requested_by", :locals => { :aktion => Aktion.find(params[:id]) }
  end

  def update_requested_by
    a = Aktion.find(params[:id])
    unless params[:requested_by] == nil
      a.requested_by_id = params[:requested_by]
      a.save
    end
    render :update do |page|
      page.replace_html "action-#{a.id}-requested_by", :partial => "action_log/table_cells/requested_by", :locals => {:aktion => a}
      page.visual_effect(:highlight, "action-#{a.id}-requested_by") unless params[:requested_by] == nil
    end
  end

  def inplace_edit_responsible
    render :partial => "inplace_edit_responsible", :locals => { :aktion => Aktion.find(params[:id]) }
  end

  def update_responsible
    a = Aktion.find(params[:id])
    unless params[:primary_responsible] == nil && params[:secondary_responsible] == nil
      a.primary_responsible_id = params[:primary_responsible]
      a.secondary_responsible_id = params[:secondary_responsible]
      a.save
    end
    render :update do |page|
      page.replace_html "action-#{a.id}-responsible", :partial => "action_log/table_cells/responsible", :locals => {:aktion => a}
      page.visual_effect(:highlight, "action-#{a.id}-responsible") unless params[:primary_responsible] == nil && params[:secondary_responsible] == nil
    end
  end

  def inplace_edit_due_date
    render :partial => "inplace_edit_due_date", :locals => { :aktion => Aktion.find(params[:id]) }
  end

  def update_due_date
    a = Aktion.find(params[:id])
    unless params[:target_date] == nil && params[:review_date] == nil
      a.new_target_date = params[:target_date]
      a.review_date = params[:review_date]
      a.save
    end
    render :update do |page|
      page.replace_html "action-#{a.id}-due_date", :partial => "action_log/table_cells/due_date", :locals => {:aktion => a}
      page.visual_effect(:highlight, "action-#{a.id}-due_date") unless params[:target_date] == nil && params[:review_date] == nil
    end
  end

end
