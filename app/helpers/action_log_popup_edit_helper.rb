module ActionLogPopupEditHelper

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

  def get_new_table_row_class(aktion, add_mode = true)
    aktion_class = 'record '
    aktion_class = aktion_class + 'new-record ' if add_mode
    aktion_class = (aktion.overdue ? "highlighted-record " : "") + aktion_class
    aktion_class = (aktion.soft_deleted? ? "deleted-record " : "") + aktion_class
    aktion_class
  end
end
