class Admin::UserController < ApplicationController
  before_filter :login_required
  deny :user => [ :is_user? ]

  layout "admin"
  active_scaffold :user do |config|
    config.actions.exclude :nested
    config.columns.exclude :events, :primary_responsibles, :secondary_responsibles, :requested_bys, :account, :responsible_users
    config.columns = [:name, :login, :pw, :email, :inactive, :role, :organizational_units, :meetings]
    config.columns[:login].label = 'Login'
    list.sorting = {:name => 'ASC'}
    config.columns[:role].form_ui = :select
    config.columns[:organizational_units].form_ui = :select
    config.columns[:meetings].form_ui = :select
  end

  def conditions_for_collection
    if current_user.organizational_units != nil && !current_user.organizational_units.empty?
      ['users.id IN (?)', User.find_all_users_of_organizational_units(current_user.organizational_units)]
    end
  end
end
