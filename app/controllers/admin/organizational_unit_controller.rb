class Admin::OrganizationalUnitController < ApplicationController
  before_filter :login_required
  deny :user => [ :is_user? ]

  layout "admin"
  active_scaffold :organizational_unit do |config|
    config.actions.exclude :nested
    #config.label = "Customers"
    #config.columns = [:name, :phone, :company_type, :comments]
    config.columns.exclude :lft, :rgt, :meetings, :users
    #list.sorting = {:name => 'ASC'}
    #columns[:phone].label = "Phone #"
    #columns[:phone].description = "(Format: ###-###-####)"
    config.columns[:parent].ui_type = :select
  end
end
