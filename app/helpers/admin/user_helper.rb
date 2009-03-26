module Admin::UserHelper
  # hook for ActiveScaffold to limit content of assocs
  def options_for_association_conditions(association)
    if association.name == :role
      ["roles.id != ?", Role::CUSTOMIZATOR] unless current_user.is_superuser?
    else if association.name == :meetings
        meetings = Meeting.find_all_meetings_of_organizational_units(current_user.organizational_units)
        ["meetings.id IN (?)", meetings]
      else
        super
      end
    end
  end
end