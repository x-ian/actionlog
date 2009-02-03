class Admin::EventAreaController < ApplicationController
  before_filter :login_required
  deny :user => [ :is_user? ]

  layout "admin"
  active_scaffold :event_area do |config|
    config.actions.exclude :nested
    #config.label = "Customers"
    #config.columns = [:name, :phone, :company_type, :comments]
    config.columns.exclude :events, :escalated_event_area
    #list.sorting = {:name => 'ASC'}
    #columns[:phone].label = "Phone #"
    #columns[:phone].description = "(Format: ###-###-####)"
    config.columns[:meeting].ui_type = :select
    config.columns[:description].options = {:rows => 4, :cols => 41}
  end
end
