class Admin::EventAreaController < ApplicationController
  before_filter :login_required
  deny :user => [ :is_user? ]

  layout "admin"
  active_scaffold :event_area do |config|
    config.actions.exclude :nested
    config.columns = [:meeting, :name, :description]
    config.columns.exclude :events, :escalated_meeting
    list.sorting = {:meeting => 'ASC'}
    config.columns[:meeting].form_ui = :select
    config.columns[:description].options = {:rows => 4, :cols => 41}
  end

  def conditions_for_collection
    if current_user.organizational_units != nil && !current_user.organizational_units.empty?
      ['meetings.organizational_unit_id IN (?)', OrganizationalUnit.find_all_organizational_units(current_user.organizational_units)]
    end
  end
end
