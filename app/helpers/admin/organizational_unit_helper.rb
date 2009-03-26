module Admin::OrganizationalUnitHelper
  # hook for ActiveScaffold to limit content of assocs
  def options_for_association_conditions(association)
    if association.name == :responsible_user
      users = User.find_all_users_of_organizational_units(current_user.organizational_units)
      ["users.id IN (?)", users]
    else if association.name == :parent
        org_units = OrganizationalUnit.find_all_organizational_units(current_user.organizational_units)
        ["organizational_units.id IN (?)", org_units]
      else
        super
      end
    end
  end
end