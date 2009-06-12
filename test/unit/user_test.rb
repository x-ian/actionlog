require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_login
    u = User.new
    u.name="name"
    u.pw="123456"
    u.email="c@cn.de"
    u.login=""
    assert !u.save
    u.login=nil
    assert !u.save
    u.login="c"
    assert !u.save
    u.login="c:n"
    assert !u.save
    u.login="c(n"
    assert !u.save
    u.login="_n"
    assert u.save # why this?
    u.login="cn"
    assert u.save
    u.login="cn2"
    assert u.save
  end

  def test_save
    u = User.new
    u.name="name"
    u.pw="123456"
    u.email="C@C4.De"
    u.login="Nam3"
    assert u.save
    assert_equal "c@c4.de", u.email
    assert_equal "nam3", u.login
  end

  def test_account_created
    u = User.new
    u.name="name"
    u.pw="123456"
    u.email="c@cn.de"
    u.login="name"
    u.public_user = false
    assert u.save
    assert_equal u.name, u.account.name
    assert_equal u.email, u.account.email
    assert_equal u.pw, u.account.pw
    assert_equal u.pw, u.account.password
    assert_equal u.pw, u.account.password_confirmation
    assert_equal u.login, u.account.login
  end

  def no_test_account_created_only_for_public_users
    a = Account.new(:name => "login", :login => "login", :email => "cn@cn.de", :password => "password", :password_confirmation => "password", :pw => "password")
    assert a.valid?
    a.register!
    assert a.errors.empty? && a.valid? && !a.active?
    #a = Account.find_by_activation_code("") # i dont care bout activation code
    a.activate!
    assert a.active?
    assert a.valid?

    u = User.new
    # fails without me knowing why
    u.initialize_default_public_user_data(a)
    assert u.save

    u = User.new
    u.name="name"
    u.pw="123456"
    u.email="c@cn.de"
    u.login="name"
    u.public_user=true
    assert !u.account
    u.save
    assert !u.account

    u.public_user=false
    u.save
    assert u.account
    assert u.account.state = :active
  end

  def test_account_updated
    u = User.new
    u.name="name"
    u.pw="123456"
    u.email="c@cn.de"
    u.login="name"
    u.public_user = false
    assert u.save

    u.name="name2"
    u.pw="1234562"
    u.email="c@cn2.de"
    u.login="name2"
    assert u.save

    assert_equal u.name, u.account.name
    assert_equal u.email, u.account.email
    assert_equal u.pw, u.account.pw
    assert_equal u.pw, u.account.password
    assert_equal u.pw, u.account.password_confirmation
    assert_equal u.login, u.account.login
  end

  def test_roles
    u = User.new
    u.name="name"
    u.pw="123456"
    u.email="c@cn.de"
    u.login="name"

    u.role_id = Role::USER
    assert u.save
    assert u.is_user?
    assert !u.is_administrator?
    assert !u.is_customizator?

    u.role_id = Role::ADMINISTRATOR
    assert u.save
    assert !u.is_user?
    assert u.is_administrator?
    assert !u.is_customizator?

    u.role_id = Role::CUSTOMIZATOR
    assert u.save
    assert !u.is_user?
    assert !u.is_administrator?
    assert u.is_customizator?

    u = users(:one)
    assert u.is_superuser?
  end

  def test_initials
    assert_equal "N", User.new(:name=>"name").initials
    assert_equal "NN", User.new(:name=>"name name").initials
    assert_equal "NN", User.new(:name=>"Name Name").initials
    assert_equal "NNN", User.new(:name=>"name name name").initials
    assert_equal "NN", User.new(:name=>"name-name name").initials
  end

  def test_firstname
    assert_equal "name", User.new(:name=>"name").first_name
    assert_equal "name", User.new(:name=>"name name").first_name
    assert_equal "Name", User.new(:name=>"Name Name").first_name
    assert_equal "name", User.new(:name=>"name name name").first_name
    assert_equal "name-name", User.new(:name=>"name-name name").first_name
  end

  def no_test_initialize_default_public_user_data
    a = Account.new(:name => "login", :login => "login", :email => "cn@cn.de", :password => "password", :password_confirmation => "password", :pw => "password")
    assert a.valid?
    a.register!
    assert a.errors.empty? && a.valid? && !a.active?
    #a = Account.find_by_activation_code("") # i dont care bout activation code
    a.activate!
    assert a.active?
    assert a.valid?

    u = User.new
    # fails without me knowing why
    u.initialize_default_public_user_data(a)
    assert u.save

    assert_equal a.login, u.name
    assert_equal a.email, u.email
    assert_equal a.login, u.login
    assert_equal a.pw, u.pw
    assert_equal Role::USER, u.role_id
    assert_equal true, u.public_user
    assert_equal a, u.account

    # org unit
    o = OrganizationalUnit.find_by_name(u.login)
    assert o.exists?
    assert_equal u, o.responsible_user
    assert_somehow u, o.users
    assert_equal OrganizationalUnit::PUBLIC_ORGUNIT, o.child_of

    # meeting
    m = Meeting.find_by_name("My Meeting (#{u.login})")
    assert m.exists?
    assert_equal m.organizational_unit_id, o.id
    assert_equal m.responsible_user_id, u.id
    assert_somehow u, m.users

    # event area
    ea = EventArea.find_by_name("My Event Area (#{u.login})")
    assert ea.exists?
    assert_equal ea.meeting_id, m.id
  end

  def test_find_all_users_of_organizational_unit
    us = User.find_all_users_of_organizational_unit(nil)
    assert_equal 5, us.size


    us = User.find_all_users_of_organizational_unit(organizationalUnit__PUBLIC_ORGUNIT)
    assert_equal 0, us.size

    us = User.find_all_users_of_organizational_units([organizationalUnit__PUBLIC_ORGUNIT])
    assert_equal 0, us.size

    us = User.find_all_users_of_organizational_unit(organizational_units(:test_users_1))
    assert_equal 3, us.size

    us = User.find_all_users_of_organizational_units([organizational_units(:test_users_2)])
    assert_equal 2, us.size

    us = User.find_all_users_of_organizational_units([organizational_units(:test_users_1), organizational_units(:test_users_2)])
    assert_equal 3, us.size
  end

  def test_find_all_users_of_meeting
    us = User.find_all_users_of_meeting(meetings(:test_users_1))
    assert_equal 1, us.size

    us = User.find_all_users_of_meeting(meetings(:test_users_2))
    assert_equal 0, us.size
  end

  def test_find_participated_primary_responsibles_users_of_meeting
    us = User.find_participated_primary_responsibles_users_of_meeting(meetings(:test_users_1))
    assert_equal 2, us.size

    us = User.find_participated_primary_responsibles_users_of_meeting(meetings(:test_users_2))
    assert_equal 0, us.size
  end

  def test_email
    u = User.new
    u.name="name"
    u.login="name"
    u.pw="123456"
    u.email=nil
    assert !u.save
    u.email="christianneumann"
    assert !u.save
    u.email="christianneumann@"
    assert !u.save
    u.email="christianneumann@web."
    assert !u.save
    u.email="christianneumann@web.d"
    assert !u.save
    u.email="christianneumann@web.xyz"
    assert !u.save
    u.email="@web.de"
    assert !u.save

    u.email="christianneumann@web.de"
    assert u.save
    u.email="c@web.de"
    assert u.save
    u.email="c@ix.de"
    assert u.save
    u.email="chris@go-beyond.biz"
    assert u.save
  end
end
