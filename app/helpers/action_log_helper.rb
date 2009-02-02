module ActionLogHelper
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

  def options_for_select_filter (elements, param, include_unassigned = false)
    s = []
    elements.each do |d|
      s.insert(0, "<option value='" + d.id.to_s + "'" + (d.id.to_s == param.to_s ? " selected='selected'>" : ">") + d.name + "</option>")
    end
    s.insert(0, "<option" + (param.blank? ? " selected='selected'>" : ">") + "</option>")
    s.insert(1, "<option value='(unassigned)'" + ("(unassigned)" == param ? " selected='selected'>" : ">") + "(unassigned)</option>") if include_unassigned
    return s
  end

  def calc_review_date(aktion_id)
    return Time.now.to_date + 28 if aktion_id.blank?
    return Time.now.to_date + 28 if Aktion.find(aktion_id).review_date.blank?
    return Aktion.find(aktion_id).review_date
  end

  def review_date_necessary(target_date)
    unless target_date.blank?
      # if target_date - today > 60 days
      days = (Time.parse(target_date) - Time.now) / 60 / 60 / 24
      return (days > (6*7))
    end
    false
  end

  def initial_review_date_necessary(aktion)
    return true unless aktion.review_date == nil
    if aktion.new_target_date != nil
      return review_date_necessary(aktion.new_target_date.to_s)
    else
      if aktion.new_target_date == nil && aktion.target_date != nil
        return review_date_necessary(aktion.target_date.to_s)
      end
    end
    false
  end

  def get_table_row_class(aktion)
    aktion_class = cycle('record', 'even-record record')
    aktion_class = (aktion.overdue ? "highlighted-record " : "") + aktion_class
    aktion_class
  end
end
