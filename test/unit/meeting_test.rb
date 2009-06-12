require 'test_helper'

class MeetingTest < ActiveSupport::TestCase
  def test_meeting_without_orgunit
    m = Meeting.new(:name => :name)
    m.organizational_unit = organizational_units(:one)
    assert !m.invalid?
    m.organizational_unit = nil
    assert m.invalid?
    assert !m.save
  end

  def test_find_all_meetings_of_org_units
    ms = Meeting.find_all_meetings_of_organizational_units([organizational_units(:one)])
    assert_equal 6, ms.size

    ms = Meeting.find_all_meetings_of_organizational_units([organizational_units(:two)])
    assert_equal 2, ms.size

    ms = Meeting.find_all_meetings_of_organizational_units([organizational_units(:three)])
    assert_equal 1, ms.size
  end

  def test_find_all_meetings_to_escalate_to
    ms = meetings(:four).find_all_meetings_to_escalate_to
    assert_equal 6, ms.size
    assert_equal "MyString", ms[0].name
    assert_equal "Meeting with private Events", ms[1].name
    assert_equal "FpmMeeting1", ms[4].name
    assert_equal "FpmMeeting2", ms[5].name
    assert_equal "CompaniesMeeting1", ms[2].name
    assert_equal "CompaniesMeeting2", ms[3].name

    ms = meetings(:six).find_all_meetings_to_escalate_to
    assert_equal 1, ms.size
    assert_equal "PublicMeeting1", ms[0].name
  end

  def test_has_private_events
    assert !meetings(:one).private_events?
    assert meetings(:two).private_events?
  end

  def test_private_events_password
    assert !meetings(:one).private_password_match?("falsch")
    assert meetings(:one).private_password_match?(nil)
    assert meetings(:one).private_password_match?("")

    assert !meetings(:two).private_password_match?("falsch")
    assert !meetings(:two).private_password_match?(nil)
    assert !meetings(:two).private_password_match?("")
    assert meetings(:two).private_password_match?("private")
  end
end
