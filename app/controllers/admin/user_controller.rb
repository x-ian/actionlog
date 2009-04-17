class Admin::UserController < ApplicationController
  before_filter :login_required
  deny :user => [ :is_user? ]

  layout "admin"
  active_scaffold :user do |config|
    config.actions.exclude :nested
    config.columns.exclude :pw, :events, :primary_responsibles, :secondary_responsibles, :requested_bys, :account, :responsible_users
    config.columns = [:name, :login, :pw, :inactive, :email, :public_user, :role, :organizational_units, :meetings]
    config.columns[:login].label = 'Login'
    config.list.columns = [:name, :login, :inactive, :email, :public_user, :role, :organizational_units, :meetings]
    list.sorting = {:name => 'ASC'}
    config.columns[:role].form_ui = :select
    config.columns[:organizational_units].form_ui = :select
    config.columns[:meetings].form_ui = :select
    config.columns[:pw].form_ui = :password
  end

  def conditions_for_collection
    if current_user.organizational_units != nil && !current_user.organizational_units.empty?
      ['users.id IN (?)', User.find_all_users_of_organizational_units(current_user.organizational_units)]
    end
  end

  def before_create_save(record)
    stupid_way_to_ensure_at_least_one_org_unit record
  end

  def before_update_save(record)
    stupid_way_to_ensure_at_least_one_org_unit record
  end

  # dont know why, but m:n association are directly saved
  # so even if validation of parent object fails, the assoc is updated. FUCK
  def stupid_way_to_ensure_at_least_one_org_unit(record)
    if !current_user.is_superuser?
      raise "Organizational units can't be blank" if record.organizational_units.empty? && !current_user.organizational_units.empty?
    end
  end

end
