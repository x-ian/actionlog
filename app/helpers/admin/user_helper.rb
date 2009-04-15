module Admin::UserHelper
  # hook for ActiveScaffold to limit content of assocs
  def options_for_association_conditions(association)
    if association.name == :role
      ["roles.id != ?", Role::CUSTOMIZATOR] unless current_user.is_superuser?
    else if association.name == :meetings
        meetings = Meeting.find_all_meetings_of_organizational_units(current_user.organizational_units)
        ["meetings.id IN (?)", meetings]
      else if association.name == :organizational_units
          org_units = OrganizationalUnit.find_all_organizational_units(current_user.organizational_units)
          ["organizational_units.id IN (?)", org_units]
        else
          super
        end
      end
    end
  end

  # ActiveScaffold
  def public_user_form_column(record, input_name)
    if current_user.is_superuser?
      check_box :record, :public_user, { :name => input_name, :disabled => false }
    else
      check_box :record, :public_user, { :name => input_name, :disabled => true }
    end
  end

end