module Admin::CustomizedSchemaHelper
  # hook for ActiveScaffold to limit content of assocs
  def options_for_association_conditions(association)
    if association.name == :organizational_unit
      org_units = OrganizationalUnit.find_all_organizational_units(current_user.organizational_units)
      ["organizational_units.id IN (?)", org_units]
    else
      super
    end
  end

end