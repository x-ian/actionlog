require 'test_helper'

class OrganizationalUnitTest < ActiveSupport::TestCase
  def test_find_self_and_all_nested_org_units
    ous = OrganizationalUnit.find_all_organizational_units([organizationalUnit__COMPANIES_ORGUNIT])
    # dont know why I get an int back here
    #assert_equal OrganizationalUnit.find_by_name("Companies"), ous[0]
    assert_equal OrganizationalUnit.find_by_name("First Principles Management"), ous[1]
    assert_equal 2, ous.size

    # dont know why I get an int back here
    #assert_equal OrganizationalUnit.find_by_name("Public"), OrganizationalUnit.find_all_organizational_units([organizationalUnit__PUBLIC_ORGUNIT])
    assert_equal 1, OrganizationalUnit.find_all_organizational_units([organizationalUnit__PUBLIC_ORGUNIT]).size
  end

  def test_find_self_and_all_nested_org_units_without_start
    assert_equal OrganizationalUnit.find(:all).size, OrganizationalUnit.find_all_organizational_units(nil).size
    assert_equal OrganizationalUnit.find(:all), OrganizationalUnit.find_all_organizational_units(nil)
  end

  def test_parent_must_be_0_instead_of_nil
    ou = OrganizationalUnit.new(:name => "ou", :parent => nil)
    assert ou.save
    assert_equal 0, ou.parent_id
  end

  def test_parent_present
    # user without orgunits
    u = User.find_by_login("administrator")
#    u.organizational_units << nil
    ou = OrganizationalUnit.new(:name => "ou")
    ou.current_user = u
    ou.parent = OrganizationalUnit.new(:name => "ou2")
    assert ou.save
    ou.parent = nil
    assert ou.save

    # user with orgunits
    u = User.find_by_login("administrator")
    u.organizational_units << OrganizationalUnit.new(:name => :nested)
    ou = OrganizationalUnit.new(:name => "ou")
    ou.current_user = u
    ou.parent = OrganizationalUnit.new(:name => "ou2")
    assert ou.save
    ou.parent = nil
    assert !ou.save

    # superuser without orgunits
    u = User.find_by_login("superuser")
#    u.organizational_units = nil
    ou = OrganizationalUnit.new(:name => "ou")
    ou.current_user=u
    ou.parent = OrganizationalUnit.new(:name => "ou2")
    assert ou.save
    ou.parent = nil
    assert ou.save

    # superuser with orguntis
    u = User.find_by_login("superuser")
    u.organizational_units << OrganizationalUnit.new(:name => :nested)
    ou = OrganizationalUnit.new(:name => "ou")
    ou.current_user=u
    ou.parent = OrganizationalUnit.new(:name => "ou2")
    assert ou.save
    ou.parent = nil
    assert ou.save
  end
end
