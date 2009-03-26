module Admin::EventAreaHelper
  # hook for ActiveScaffold to limit content of assocs
  def options_for_association_conditions(association)
    if association.name == :meeting
      meetings = Meeting.find_all_meetings_of_organizational_units(current_user.organizational_units)
      ["meetings.id IN (?)", meetings]
    else
      super
    end
  end
end

