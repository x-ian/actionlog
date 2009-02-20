class MeetingMinutesController < ApplicationController

  before_filter :login_required

  def index
    if params[:owner].blank? && params[:event_area].blank? && params[:meeting_date].blank? && params[:meeting].blank?
      @minutes = Minute.find_all_minutes_of_meeting(current_meeting)
    else
      #directly called via link
      #maybe current meeting is not the same as given in the link, change it
      # TODO: check if switch is allowed
      session[:current_meeting] = Meeting.find(params[:meeting]) unless params[:meeting].blank?
      @minutes = Minute.find_all_by_filter_form(params, current_meeting)
    end
  end

  def create_minute
    m = Minute.new(params[:minute])

    respond_to do |format|
      if m.save
        flash[:notice] = 'Minute was successfully created.'
        format.html { redirect_to(:action => "index") }
        format.js {
          render :update do |page|
            page.insert_html :after, :first_empty_row, :partial => "minutes_tr", :locals => { :minute => m }
            page.visual_effect(:highlight, "minute-#{m.id}-area")
            page.visual_effect(:highlight, "minute-#{m.id}-meeting")
            page.visual_effect(:highlight, "minute-#{m.id}-name")
            page.visual_effect(:highlight, "minute-#{m.id}-owner")
          end
        }
      else
        flash[:error] = 'Error while creating minute.'
        format.html { render :action => "index" }
      end
    end
  end

  def destroy_minute
    m = Minute.find(params[:id])
    m.destroy

    respond_to do |format|
      flash[:notice] = 'Minute was deleted.'
      format.html { redirect_to(:action => "index") }
    end
  end

  def inplace_edit_area
    render :partial => "inplace_edit_area", :locals => { :minute => Minute.find(params[:id]), :meeting_id => current_meeting.id }
  end

  def update_area
    a = Minute.find(params[:id])
    unless params[:event_area] == nil
      a.event_area_id = params[:event_area]
      a.save
    end
    render :update do |page|
      page.replace_html "minute-#{a.id}", :partial => "minutes_row", :locals => {:minute => a}
      page.visual_effect(:highlight, "minute-#{a.id}-area") unless params[:event_area] == nil
    end
  end

  def inplace_edit_meeting
    render :partial => "inplace_edit_meeting", :locals => { :minute => Minute.find(params[:id]) }
  end

  def update_meeting
    a = Minute.find(params[:id])
    unless params[:meeting_date] == nil
      a.meeting_date = params[:meeting_date]
      a.save
    end
    render :update do |page|
      page.replace_html "minute-#{a.id}", :partial => "minutes_row", :locals => {:minute => a}
      page.visual_effect(:highlight, "minute-#{a.id}-meeting") unless params[:meeting_date] == nil
    end
  end

  def inplace_edit_name
    render :partial => "inplace_edit_name", :locals => { :minute => Minute.find(params[:id]) }
  end

  def update_name
    a = Minute.find(params[:id])
    unless params[:name] == nil
      a.name = params[:name]
      a.save
    end
    render :update do |page|
      page.replace_html "minute-#{a.id}", :partial => "minutes_row", :locals => {:minute => a}
      page.visual_effect(:highlight, "minute-#{a.id}-name") unless params[:name] == nil
    end
  end

  def inplace_edit_owner
    render :partial => "inplace_edit_owner", :locals => { :minute => Minute.find(params[:id]) }
  end

  def update_owner
    a = Minute.find(params[:id])
    unless params[:user] == nil
      a.user_id = params[:user]
      a.save
    end
    render :update do |page|
      page.replace_html "minute-#{a.id}", :partial => "minutes_row", :locals => {:minute => a}
      page.visual_effect(:highlight, "minute-#{a.id}-owner") unless params[:user] == nil
    end
  end

  def apply_filter
    @minutes = Minute.find_all_by_filter_form(params, current_meeting)
    render :update do |page|
      page[:filter].replace_html :partial => 'filter',  :locals => { :meeting_id => current_meeting.id, :event_area => params[:event_area], :meeting_date => params[:meeting_date], :owner => params[:owner] }
      page[:minutes].replace_html :partial => 'minutes', :locals => {}
    end
  end

end
