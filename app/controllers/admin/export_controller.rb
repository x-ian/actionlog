class Admin::ExportController < ApplicationController

  before_filter :login_required

  def index
  end

  def export_csv
    send_data generate_csv, :filename => 'action_log.csv'
  end

  def generate_csv
    l = "ID;Days Overdue;Area;Equipment;Meeting Date;Event Type;Event;Action Required;Resp Prim;Resp Sec;WO?;Review Date;Target Date;New Target Date;Compl?;Actual Completion Date;Entered by;Closeout Comments / Actions Taken\n"
    Aktion.find(:all).each do |a|
      l += ";;;;"
      l += nil2empty(a.event.log_date) unless a.event_id == nil
      l += ";"
      l += a.event.event_type.name unless a.event_id == nil
      l += ";"
      l += a.event.name unless a.event_id == nil
      l += ";"
      l += a.action_required + ";"
      l += a.primary_responsible.name unless a.primary_responsible_id == nil
      l += ";"
      l += a.secondary_responsible.name unless a.secondary_responsible_id == nil
      l += ";"
      l += ";"
      l += nil2empty(a.review_date) + ";"
      l += nil2empty(a.target_date) + ";"
      l += nil2empty(a.new_target_date) + ";"
      l += ";"
      l += nil2empty(a.actual_completion_date) + ";"
      l += a.requested_by.name unless a.requested_by_id == nil
      l += ";"
      l += a.closeout_comment
      l += "\n"
    end
    l
  end

  def nil2empty(value)
    return "" if value == nil
    return value.to_s
  end
end
