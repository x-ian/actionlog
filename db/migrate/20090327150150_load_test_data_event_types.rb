require 'active_record/fixtures'

class LoadTestDataEventTypes < ActiveRecord::Migration
  def self.up
    down
    directory = File.join( File.dirname(__FILE__) , 'data' )

    # configuration
    Fixtures.create_fixtures(directory, 'event_types')
  end

  def self.down
    # configuration
    EventType.delete_all
  end
end
