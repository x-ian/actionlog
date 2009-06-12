require 'test_helper'

class MinuteTest < ActiveSupport::TestCase
  def test_find_all_minutes_of_meeting
    assert Minute.find_all_minutes_of_meeting(nil).empty?

    m = Minute.find_all_minutes_of_meeting(meetings(:nine))
    assert !m.empty?
    assert_equal 3, m.size
  end

  def test_find_latest_minutes_of_meeting
    assert Minute.find_latest_minutes_of_meeting(nil).empty?

    m = Minute.find_latest_minutes_of_meeting(meetings(:nine))
    assert !m.empty?
    assert_equal 1, m.size
  end

  def test_find_all_by_filter_form
    params = {:event_area => 1, :owner => "", :meeting_date => ""}

    ms = Minute.find_all_by_filter_form({}, meetings(:nine))
    assert_equal 3, ms.size

    params = {:event_area => 3}
    ms = Minute.find_all_by_filter_form(params, meetings(:nine))
    assert_equal 2, ms.size

    params = {:owner => 1}
    ms = Minute.find_all_by_filter_form(params, meetings(:nine))
    assert_equal 1, ms.size

    params = {:meeting_date => "2009-02-20"}
    ms = Minute.find_all_by_filter_form(params, meetings(:nine))
    assert_equal 2, ms.size

    params = {:event_area => 4, :meeting_date => "2009-02-21", :owner => 3}
    ms = Minute.find_all_by_filter_form(params, meetings(:nine))
    assert_equal 1, ms.size
  end
end
