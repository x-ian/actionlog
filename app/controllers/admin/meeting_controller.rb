class Admin::MeetingController < ApplicationController
  before_filter :login_required
  deny :user => [ :is_user? ]

  layout "admin"
  active_scaffold :meeting do |config|
    config.actions.exclude :nested
    #config.label = "Customers"
    #config.columns = [:name, :phone, :company_type, :comments]
    config.columns.exclude :event_areas
    config.columns.exclude :users
    #list.sorting = {:name => 'ASC'}
    #columns[:phone].label = "Phone #"
    #columns[:phone].description = "(Format: ###-###-####)"
    config.columns[:organizational_unit].ui_type = :select
    config.columns[:event_areas].ui_type = :select
    config.columns[:description].options = {:rows => 4, :cols => 41}
  end
end
