require 'active_record/fixtures'

class LoadTestDataActionTypes < ActiveRecord::Migration
  def self.up
    down
    directory = File.join( File.dirname(__FILE__) , 'data' )

    # configuration
    Fixtures.create_fixtures(directory, 'action_types')
  end

  def self.down
    ActionType.delete_all
  end
end
