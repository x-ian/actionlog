class Customization::ActionPriorityController < ApplicationController
  before_filter :login_required
  deny :user => [ :is_user?, :is_administrator? ]

  layout "admin"
  active_scaffold :action_priority do |config|
    #config.label = "Customers"
    #config.columns = [:name, :phone, :company_type, :comments]
    config.columns.exclude :aktions
    #list.sorting = {:name => 'ASC'}
    #columns[:phone].label = "Phone #"
    #columns[:phone].description = "(Format: ###-###-####)"
  end
end
