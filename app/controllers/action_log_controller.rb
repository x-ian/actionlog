class ActionLogController < ApplicationController

  before_filter :login_required

  def init_event
    @event = Event.new_with_defaults current_meeting
    #@event.default_meeting = current_account.user.meeting unless current_account.nil? || current_account.user.nil?
    @event.event_area_id = Event.find(flash[:last_used_event_id]).event_area_id unless flash[:last_used_event_id] == nil
    #@event.meeting_date = Time.now.to_date
  end

  def init_action
    @aktion = Aktion.new
    #@aktion.default_meeting = current_account.user.meeting unless current_account.nil? || current_account.user.nil?
    @aktion.event_id = flash[:last_used_event_id] unless flash[:last_used_event_id] == nil
    @aktion.assignment_date = Time.now.to_date
    @aktion.requested_by_id = current_user.id
    @aktion.primary_responsible_id = current_user.id
  end

  def init_events_and_actions
    @aktions = []
    @events = []
    @aktions = Aktion.find_all_by_filter_form(params, current_meeting, params[:page], session[:actions_per_page]) if session[:action_log_current_view] == "grouped_by_actions"
    @events = Event.find_all_by_filter_form(params, current_meeting) if session[:action_log_current_view] == "grouped_by_events"
  end

  def index
    init_event

    init_action

    @edit_event = false
    if params.key?(:edit_event)
      @event = Event.find(params[:edit_event])
      @edit_event = true
    end
    @edit_action = false
    if params.key?(:edit_action)
      @aktion = Aktion.find(params[:edit_action])
      @edit_action = true
    end

    # default
    session[:action_log_current_view] = "grouped_by_actions" if session[:action_log_current_view].blank?
    params[:action_status] = ActionStatus::UNCOMPLETED if params[:action_status] == nil
    session[:actions_per_page] = "(all)" if session[:actions_per_page].blank?
    session[:cut_text] ="no" if session[:cut_text].blank?
    session[:font_size] = "auto" if session[:font_size].blank?
    session[:table_width] = "100%" if session[:table_width].blank?

    init_events_and_actions

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def set_current_meeting
    if params[:current_meeting].blank?
      session[:current_meeting] = nil
    elsif params[:current_meeting] == "(all)"
      session[:current_meeting] = "(all)"
    else
      if Meeting.find(params[:current_meeting]).invalid?
        flash[:error] = "Selected meeting is invalid."
        session[:current_meeting] = nil
      else
        session[:current_meeting] = Meeting.find(params[:current_meeting])
      end
    end
    respond_to do |format|
      format.html { redirect_to(:action => "index") }
    end
  end

  def set_paginate_size
    session[:actions_per_page] = params[:actions_per_page]
    respond_to do |format|
      format.html { redirect_to(:action => "index") }
    end
  end

  def set_table_properties
    session[:font_size] = params[:font_size]
    session[:cut_text] = params[:cut_text]
    session[:table_width] = params[:table_width]
    respond_to do |format|
      format.html { redirect_to(:action => "index") }
    end
  end

  def apply_filter
    params[:page] = 1
    @aktions = Aktion.find_all_by_filter_form(params, current_meeting, params[:page], session[:actions_per_page]) if session[:action_log_current_view] == "grouped_by_actions"
    @events = Event.find_all_by_filter_form(params, current_meeting) if session[:action_log_current_view] == "grouped_by_events"
    render :update do |page|
      page[:index_filter].replace_html :partial => 'index_filter',  :locals => { :action_status => params[:action_status], :requested => params[:requested], :responsible => params[:responsible], :to => params[:to], :from => params[:from], }
      page[:index_actions].replace_html :partial => 'index_actions_grouped_by_events', :locals => {} if session[:action_log_current_view] == "grouped_by_events"
      page[:index_actions].replace_html :partial => 'index_actions_grouped_by_actions', :locals => {} if session[:action_log_current_view] == "grouped_by_actions"
    end
  end

  def index_grouped_by_events
    session[:action_log_current_view] = "grouped_by_events"
    @events = Event.find_all_by_filter_form(params, current_meeting)
    @aktions = []
    render :update do |page|
      page[:index_filter].replace_html :partial => 'index_filter',  :locals => { :action_status => params[:action_status], :requested => params[:requested], :responsible => params[:responsible], :to => params[:to], :from => params[:from], }
      page[:index_actions].replace_html :partial => 'index_actions_grouped_by_events', :locals => {}
    end
  end

  def index_grouped_by_actions
    session[:action_log_current_view] = "grouped_by_actions" 
    session[:actions_per_page] = "(all)"
    @events = []
    @aktions = Aktion.find_all_by_filter_form(params, current_meeting, params[:page])
    render :update do |page|
      page[:index_filter].replace_html :partial => 'index_filter',  :locals => { :action_status => params[:action_status], :requested => params[:requested], :responsible => params[:responsible], :to => params[:to], :from => params[:from], }
      page[:index_actions].replace_html :partial => 'index_actions_grouped_by_actions', :locals => {}
    end
  end

  def create_event
    if params[:event_type] == "Minute"
      # hack to create a meeting minute as a faked event
      m = Minute.new
      m.meeting_date = params[:meeting_date]
      m.user_id = params[:event][:user_id]
      m.event_area_id = params[:my_event_area_id]
      m.name = params[:event][:name]
      respond_to do |format|
        if m.save
          flash[:notice] = 'Minute was successfully created (see ActionLog - Meeting Minutes)'
          format.html { redirect_to(:action => "index") }
          format.js
        else
          flash[:error] = 'Error while creating minute.'
          init_action
          init_events_and_actions
          format.html { render :action => "index" }
        end
      end
    else
      @event = Event.new(params[:event])
      @event.assign_priorities(collect_priority_values(params))
      @event.event_type = EventType.find_by_name(params["event_type"]) unless params["event_type"].blank?
      @event.event_area_id = params[:my_event_area_id] unless params[:my_event_area_id].blank?
      @event.meeting_date = Time.now.to_date if params[:aktion_assignment_date].blank?

      respond_to do |format|
        if @event.save
          flash[:notice] = 'Event was successfully created.'
          flash[:last_used_event_id] = @event.id
          format.html { redirect_to(:action => "index") }
          format.js
        else
          flash[:error] = 'Error while creating event.'
          init_action
          init_events_and_actions
          format.html { render :action => "index" }
        end
      end
    end
  end

  def collect_priority_values(params)
    params.select { |key,value| key.starts_with?("priority_axis_") }
  end

  def create_action
    @aktion = Aktion.new(params[:aktion])
    @aktion.action_type = ActionType.find_by_name(params["action_type"]) unless params["action_type"].blank?
    @aktion.event_id = params[:my_event_id] unless params[:my_event_id].blank?
    @aktion.assignment_date = Time.now.to_date if params[:aktion_assignment_date].blank?

    respond_to do |format|
      if @aktion.save
        flash[:last_used_event_id] = @aktion.event_id
        flash[:notice] = 'Action was successfully created.'
        format.html { redirect_to(:action => "index") }
      else
        flash[:error] = 'Error while creating action.'
        init_event
        init_events_and_actions
        format.html { render :action => "index" }
      end
    end
  end

  def show_popup_closeout_comment
    aktion = Aktion.find(params[:id])

    render :update do |page|
      toggle_select_boxes_for_popups page
      page.replace_html "popup_action_complete_closeout_comment", :partial => "action_log/actions/popup_action_closeout_comment", :locals => {:aktion => aktion }
      page << "$('action_closeout_comment_popup').popup.show();"
    end
  end

  def complete_action
    if params[:aktion]=="cancel"
      render :update do |page|
        toggle_select_boxes_for_popups page
        page << "$('action_closeout_comment_popup').popup.hide();"
      end
      return
    end
    unless params[:id].blank?
      a = Aktion.find(params[:id])
      a.complete! params[:closeout_comment], current_user
      render :update do |page|
        toggle_select_boxes_for_popups page
        page.replace_html "action-#{a.id}", :partial => "index_actions_grouped_by_actions_row", :locals => {:aktion => a}
        highlight_changed_row page, a
      end
    end
  end

  def auto_complete_for_aktion_action_required
    @bitems = nil
    if params[:aktion][:action_required] != nil
      @bitems = ActionVerb.good_verbs
      @bitems.insert(0, ActionVerb.new(:verb => params[:aktion][:action_required]))
    end
    render :inline => "<%= auto_complete_result @bitems, 'verb' %>"
  end

  def check_action_required
    @action_status = "50"
    @action_status_text = ""

    unless params[:verb].blank?
      if ActionVerb.bad_verb(params[:verb])
        @action_status = "5 "
        @action_status_text = "(bad verb)"
      elsif ActionVerb.good_verb(params[:verb])
        @action_status = "100"
        @action_status_text = "(good verb)"
      end
    end
    respond_to do |format|
      format.js
    end
  end

  def fill_meeting_select
    orgunit_id = ""
    orgunit_id = params[:id] unless params[:id].blank?
    render :update do |page|
      page.replace_html "meeting_select", :partial => "action_log/events/meeting_select", :locals => {:orgunit_id => orgunit_id, :event => nil}
    end
  end

  def fill_event_area_select
    meeting_id = ""
    meeting_id = params[:id] unless params[:id].blank?
    render :update do |page|
      page.replace_html "event_area_select", :partial => "action_log/events/event_area_select", :locals => {:meeting_id => meeting_id, :eventarea_id => ""}
    end
  end

  def fill_meeting_select_for_action
    orgunit_id = ""
    orgunit_id = params[:id] unless params[:id].blank?
    render :update do |page|
      page.replace_html "action_meeting_select", :partial => "action_log/actions/meeting_select", :locals => {:orgunit_id => orgunit_id, :aktion => nil}
    end
  end

  def fill_event_area_select_for_action
    meeting_id = ""
    meeting_id = params[:id] unless params[:id].blank?
    render :update do |page|
      page.replace_html "action_event_area_select", :partial => "action_log/actions/event_area_select", :locals => {:meeting_id => meeting_id, :eventarea_id => ""}
    end
  end

  def show_secondary_responsible
    render :update do |page|
      page.visual_effect(:blind_down, "secondary_responsible") unless params[:id].blank?
      page.visual_effect(:blind_up, "secondary_responsible") if params[:id].blank?
    end
  end

  def show_review_date
    render :update do |page|
      page.visual_effect(:blind_down, "review_date") if review_date_necessary(params[:value])
      page[:aktion_review_date].value = calc_review_date(params[:id]) if review_date_necessary(params[:value])
      page.visual_effect(:blind_up, "review_date") unless review_date_necessary(params[:value])
    end
  end

  def fill_event_select_for_action
    event_area_id = ""
    event_area_id = params[:id] unless params[:id].blank?
    render :update do |page|
      page.replace_html "action_event_select", :partial => "action_log/actions/event_select", :locals => { :event_area_id => event_area_id }
    end
  end

  def edit_event
    respond_to do |format|
      format.html { redirect_to(:action => "index", :edit_event => params[:id]) }
    end
  end

  def edit_event_remote
    @event = Aktion.find(params[:id]).event
    render :update do |page|
      page.replace_html "action-#{params[:id]}", :partial => "action_log/events/edit_event_remote", :locals => { :aktion => Aktion.find(params[:id]), :event => @event }
    end
  end

  def edit_event_remote_for_events_without_actions
    @event = Event.find(params[:id])
    render :update do |page|
      page.replace_html "event-without-action-#{params[:id]}", :partial => "action_log/events/edit_event_remote", :locals => { :event => @event }
      #page.replace_html "action-89", :partial => "action_log/events/edit_event_remote", :locals => { :aktion => Aktion.find(89), :event => event }
      #page.replace_html "action-89", "ABC"
    end
  end

  def add_action_to_event_remote
    @event = Event.find(params[:id])
    @aktion = Aktion.new
    @aktion.event_id = @event.id
    render :update do |page|
      page.replace_html "event-without-action-#{params[:id]}", :partial => "action_log/actions/new_action_1", :locals => { :aktion => @aktion }
    end
  end

  def update_event
    @event = Event.find(params[:id])
    @event.assign_priorities(collect_priority_values(params))
    @event.event_type = EventType.find_by_name(params["event_type"]) unless params["event_type"].blank?
    @event.event_area_id = params[:my_event_area_id] unless params[:my_event_area_id].blank?

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
      else
        flash[:error] = 'Error while updating event.'
      end
      format.html { redirect_to(:action => "index") }
    end
  end

  def destroy_event
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      flash[:notice] = 'Event was deleted.'
      format.html { redirect_to(:action => "index") }
    end
  end

  def edit_action
    respond_to do |format|
      format.html { redirect_to(:action => "index", :edit_action => params[:id]) }
    end
  end

  def edit_action_remote
    @aktion = Aktion.find(params[:id])
    render :update do |page|
      page.replace_html "action-#{params[:id]}", :partial => "action_log/actions/edit_action_remote", :locals => { :aktion => @aktion }
    end
  end

  def update_action
    @aktion = Aktion.find(params[:id])
    @aktion.action_type = ActionType.find_by_name(params["action_type"]) unless params["action_type"].blank?
    @aktion.event_id = params[:my_event_id] unless params[:my_event_id].blank?

    respond_to do |format|
      if @aktion.update_attributes(params[:aktion])
        flash[:notice] = 'Action was successfully updated.'
      else
        flash[:error] = 'Error while updating action.'
      end
      format.html { redirect_to(:action => "index") }
    end
  end

  def destroy_action
    @aktion = Aktion.find(params[:id])
    @aktion.soft_delete

    respond_to do |format|
      flash[:notice] = 'Action was deleted.'
      format.html { redirect_to(:action => "index") }
    end
  end
end
