class Admin::OrganizationalUnitController < ApplicationController
  before_filter :login_required
  deny :user => [ :is_user? ]

  # hook for ActiveScaffold to update betternestedset
  def after_create_save(record)
    record.move_to_child_of record.parent.id unless record.parent.nil?
  end

  layout "admin"
  active_scaffold :organizational_unit do |config|
    config.actions.exclude :nested
    config.columns = [:parent, :name, :responsible_user, :description]
    config.columns.exclude :lft, :rgt, :meetings, :users
    list.sorting = {:parent => 'ASC'}
    config.columns[:parent].form_ui = :select
    config.columns[:description].options = {:rows => 4, :cols => 41}
    config.columns[:responsible_user].form_ui = :select
  end

  def conditions_for_collection
    if current_user.organizational_units != nil && !current_user.organizational_units.empty?
      ['organizational_units.id IN (?)', OrganizationalUnit.find_all_organizational_units(current_user.organizational_units)]
    end
  end
end
