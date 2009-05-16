class Admin::CustomizedSchemaController < ApplicationController
  before_filter :login_required
  deny :user => [ :is_user? ]

  layout "admin"
  active_scaffold :customized_schema do |config|
    config.actions.exclude :nested
    #config.columns.exclude :pw, :events, :primary_responsibles, :secondary_responsibles, :requested_bys, :account, :responsible_users
    config.columns = [:organizational_unit, :customized_field_type, :name, :size, :description]
    #config.list.columns = [:name, :login, :inactive, :email, :public_user, :role, :organizational_units, :meetings]
    list.sorting = {:customized_field_type => 'ASC'}
    config.columns[:customized_field_type].form_ui = :select
    config.columns[:organizational_unit].form_ui = :select
    config.columns[:description].options = {:rows => 4, :cols => 41}
  end

  def conditions_for_collection
    if current_user.organizational_units != nil && !current_user.organizational_units.empty?
      ['organizational_unit_id IN (?)', OrganizationalUnit.find_all_organizational_units(current_user.organizational_units)]
    end
  end

end
