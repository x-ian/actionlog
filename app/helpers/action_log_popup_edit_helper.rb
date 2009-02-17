module ActionLogPopupEditHelper
  def create_collection_select_tag_options(object, list, include_blank, value_method, text_method)
    tag = ""
    tag = "<option></option>" if include_blank
    list.each do |i|
      if object != nil && object.send(value_method) == i.send(value_method)
        tag += "<option selected='selected' value=#{object.send(value_method)}>" + i.send(text_method) + "</option>"
      else
        tag += "<option value='#{i.send(value_method)}'>" + i.send(text_method) + "</option>"
      end

    end
    return tag
  end

  def review_date_necessary(target_date, aktion)
    return true unless aktion.review_date.blank?
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
      return review_date_necessary(aktion.new_target_date.to_s, aktion)
    else
      if aktion.new_target_date == nil && aktion.target_date != nil
        return review_date_necessary(aktion.target_date.to_s, aktion)
      end
    end
    false
  end

end
