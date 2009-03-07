class Customization::PriorityAxisController < ApplicationController
  before_filter :login_required
  deny :user => [ :is_user?, :is_administrator? ]

  layout "admin"
  active_scaffold :priority_axis do |config|
    #config.actions.exclude :nested
    #config.label = "Customers"
    #config.columns = [:name, :phone, :company_type, :comments]
    #config.columns.exclude :priority_axis, :priorities
    #list.sorting = {:name => 'ASC'}
    #columns[:phone].label = "Phone #"
    #columns[:phone].description = "(Format: ###-###-####)"
    config.columns[:description].options = {:rows => 4, :cols => 41}
    #config.columns[:description].inplace_edit = true
  end
end
