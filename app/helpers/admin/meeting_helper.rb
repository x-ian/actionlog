module Admin::MeetingHelper
  # hook for ActiveScaffold to limit content of assocs
  def options_for_association_conditions(association)
    if association.name == :responsible_user
      users = User.find_all_users_of_organizational_units(current_user.organizational_units)
      ["users.id IN (?)", users]
    else if association.name == :organizational_unit
        org_units = OrganizationalUnit.find_all_organizational_units(current_user.organizational_units)
        ["organizational_units.id IN (?)", org_units]
      else
        super
      end
    end
  end

  # ActiveScaffold
  def private_events_password_form_column(record, input_name)
    text_field :record, :private_events_password, :name => input_name
  end
end
