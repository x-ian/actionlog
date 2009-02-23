module ActionLogHelper
  def create_select_tag_options2(object, list)
    tag = ""
    list.each do |i|
      if object != nil && object == i
        tag += "<option selected='selected'>" + i + "</option>"
      else
        tag += "<option>" + i + "</option>"
      end

    end
    return tag
  end

  def create_select_tag_options(object, list, include_blank)
    tag = ""
    tag = "<option></option>" if include_blank
    list.each do |i|
      if object != nil && object.value == i.value
        tag += "<option selected='selected'>" + i.value + "</option>"
      else
        tag += "<option>" + i.value + "</option>"
      end

    end
    return tag
  end

  def options_for_select_filter (elements, param, include_unassigned = false, include_all = false)
    s = []
    elements.each do |d|
      s.insert(0, "<option value='" + d.id.to_s + "'" + (d.id.to_s == param.to_s ? " selected='selected'>" : ">") + d.name + "</option>")
    end
    s.insert(0, "<option" + (param.blank? ? " selected='selected'>" : ">") + "</option>")
    s.insert(1, "<option value='(unassigned)'" + ("(unassigned)" == param ? " selected='selected'>" : ">") + "(unassigned)</option>") if include_unassigned
    s.insert(1, "<option value='(all)'" + ("(all)" == param ? " selected='selected'>" : ">") + "(all)</option>") if include_all
    return s
  end

  def calc_review_date(aktion_id)
    return Time.now.to_date + 28 if aktion_id.blank?
    return Time.now.to_date + 28 if Aktion.find(aktion_id).review_date.blank?
    return Aktion.find(aktion_id).review_date
  end

  def get_table_row_class(aktion)
    aktion_class = cycle('record', 'even-record record')
    aktion_class = (aktion.overdue ? "highlighted-record " : "") + aktion_class
    aktion_class
  end

  def highlight_changed_row(page, aktion)
    page.visual_effect(:highlight, "action-#{aktion.id}-event", :duration => 2)
    page.visual_effect(:highlight, "action-#{aktion.id}-action_required", :duration => 2)
    page.visual_effect(:highlight, "action-#{aktion.id}-requested_by", :duration => 2)
    page.visual_effect(:highlight, "action-#{aktion.id}-responsible", :duration => 2)
    page.visual_effect(:highlight, "action-#{aktion.id}-due_date", :duration => 2)
    page.visual_effect(:highlight, "action-#{aktion.id}-completion_date", :duration => 2)
    page.visual_effect(:highlight, "action-#{aktion.id}-action_status", :duration => 2)
  end

  def toggle_select_boxes_for_popups page
    if is_ie6?
      page.toggle "cut_text", "font_size", "table_width", "actions_per_page" unless session[:action_log_current_view] == "grouped_by_events"
      page.toggle "event_user_id", "event_event_area_id"
      page.toggle "aktion_requested_by_id", "aktion_primary_responsible_id", "aktion_secondary_responsible_id", "aktion_event_area_id", "aktion_event_id"
      page.toggle "filter_action_status", "filter_requested", "filter_responsible"
    end
  end

end
