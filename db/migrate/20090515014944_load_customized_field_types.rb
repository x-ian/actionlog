require 'active_record/fixtures'

class LoadCustomizedFieldTypes < ActiveRecord::Migration
  def self.up
    down
    directory = File.join( File.dirname(__FILE__) , 'data' )

    # configuration
    Fixtures.create_fixtures(directory, 'customized_field_types')
  end

  def self.down
    # configuration
    CustomizedFieldType.delete_all
  end
end
