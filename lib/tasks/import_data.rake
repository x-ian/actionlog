require 'active_record/fixtures'

namespace :actionlog do
  desc "import useful defaults"
  task(:import_useful_defaults => :environment) do
    directory = File.join( File.dirname(__FILE__) , 'useful_defaults_data' )
    Fixtures.create_fixtures(directory, 'event_areas')
    Fixtures.create_fixtures(directory, 'meetings')
    Fixtures.create_fixtures(directory, 'organizational_units')
    create_neumann
    create_franklin
  end

    def create_franklin
    return unless User.find_by_name("Mark Franklin") == nil
    u = User.new(:name=>"Mark Franklin")
    u.login="franklin"
    u.pw = "franklin"
    #u.email="mark.franklin@firstprinciplesmanagement.com"
    u.email="christian.neumann@firstprinciplesmanagement.com"
    u.role_id=1
    u.public_user=false
    u.save
  end

  def create_neumann
    return unless User.find_by_name("Christian Neumann") == nil
    u = User.new(:name=>"Christian Neumann")
    u.login="neumann"
    u.pw = "neumann"
    u.email="christian.neumann@firstprinciplesmanagement.com"
    u.role_id=1
    u.public_user=false
    u.save
  end

  desc "import fixed data"
  task(:import_fixed_data => :environment) do
    import_domain_values
    import_customizable_defaults
    create_superuser
    create_administrator
  end

  def import_domain_values
    directory = File.join( File.dirname(__FILE__) , 'customized_data' )
    Fixtures.create_fixtures(directory, 'action_statuses')
    Fixtures.create_fixtures(directory, 'action_types')
    Fixtures.create_fixtures(directory, 'customized_field_types')
    Fixtures.create_fixtures(directory, 'event_types')
    Fixtures.create_fixtures(directory, 'roles')
  end

  def import_customizable_defaults
    directory = File.join( File.dirname(__FILE__) , 'customized_data' )
    Fixtures.create_fixtures(directory, 'action_priorities')
    Fixtures.create_fixtures(directory, 'action_verbs')
    Fixtures.create_fixtures(directory, 'priority_axes')
    Fixtures.create_fixtures(directory, 'priority_ranges')
  end

  def create_superuser
    return unless User.find_by_name("Superuser") == nil
    u = User.new(:name=>"Superuser")
    u.login="superuser"
    u.pw = "superuser"
    u.email="admin@firstprinciplesmanagement.com"
    u.role_id=3
    u.public_user=false
    u.save
  end

  def create_administrator
    return unless User.find_by_name("Administrator") == nil
    u = User.new(:name=>"Administrator")
    u.login="administrator"
    u.pw = "administrator"
    u.email="admin@firstprinciplesmanagement.com"
    u.role_id=2
    u.public_user=false
    u.save
  end

end
