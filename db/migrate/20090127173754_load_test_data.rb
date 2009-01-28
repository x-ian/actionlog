require 'active_record/fixtures'

class LoadTestData < ActiveRecord::Migration
  def self.up
    down
    directory = File.join( File.dirname(__FILE__) , 'data' )

    # configuration
    Fixtures.create_fixtures(directory, 'action_priorities')
    Fixtures.create_fixtures(directory, 'action_statuses')
    Fixtures.create_fixtures(directory, 'action_verbs')
    Fixtures.create_fixtures(directory, 'event_types')
    Fixtures.create_fixtures(directory, 'priority_axes')
    Fixtures.create_fixtures(directory, 'priority_ranges')
    Fixtures.create_fixtures(directory, 'roles')


    # testdata
    Fixtures.create_fixtures(directory, 'event_areas')
    Fixtures.create_fixtures(directory, 'organizational_units')
    Fixtures.create_fixtures(directory, 'meetings')
    Fixtures.create_fixtures(directory, 'users')
  end

  def self.down
    # configuration
    ActionPriority.delete_all
    ActionVerb.delete_all
    EventType.delete_all
    PriorityAxis.delete_all
    PriorityRange.delete_all

    # testdata
    EventArea.delete_all
    OrganizationalUnit.delete_all
    Meeting.delete_all
    User.delete_all

    ActionStatus.delete_all
    Role.delete_all

  end
end
