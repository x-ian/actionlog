class Admin::UserController < ApplicationController
  before_filter :login_required
  deny :user => [ :is_user? ]

  layout "admin"
  active_scaffold :user do |config|
    #config.label = "Customers"
    #config.columns = [:name, :phone, :company_type, :comments]
    config.actions.exclude :nested
    config.columns.exclude :events, :primary_responsibles, :secondary_responsibles, :requested_bys, :account
    config.columns << :login
    config.columns[:login].label = 'Login'
    #list.sorting = {:name => 'ASC'}
    #columns[:phone].label = "Phone #"
    #columns[:phone].description = "(Format: ###-###-####)"
    config.columns[:role].ui_type = :select
    config.columns[:organizational_units].ui_type = :select
    config.columns[:meetings].ui_type = :select
  end
end
