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
    config.columns[:organizational_unit].form_ui = :select
    config.columns[:event_areas].form_ui = :select
    config.columns[:description].options = {:rows => 4, :cols => 41}
    config.columns[:responsible_user].form_ui = :select
  end

  def conditions_for_collection
    if current_user.organizational_units != nil && !current_user.organizational_units.empty?
      ['organizational_unit_id IN (?)', OrganizationalUnit.find_all_organizational_units(current_user.organizational_units)]
    end
  end
end
