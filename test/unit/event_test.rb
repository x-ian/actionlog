require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_log_date
    e = events(:test_events_1)
    assert_equal "2009-06-10", e.log_date.to_s
    e.name = "Test_Events_1"
    assert e.save
    assert_equal Time.now.to_date, e.log_date
  end

  def test_new_with_defaults
    meeting = meetings(:test_events_1)
    e = Event.new_with_defaults(meeting)
    assert_equal e.user_id, meeting.responsible_user_id
    assert_equal e.meeting_date, Time.now.to_date
    assert_equal e.event_type_id, EventType::ISSUE
    assert_equal e.event_area, EventArea.find_by_meeting_id(meeting)
  end

  def no_test_status
    e = events(:test_events_1)
    print e.aktions.to_yaml
    a=Aktion.new(:action_required=>"COMPLETED")
    a.action_status_id = ActionStatus::COMPLETED
    a.event_id = e.id
    e.aktions << a
    assert a.save
    a.complete!("comment", nil)
    assert a.save
    assert e.save
    print a.to_yaml
    print e.to_yaml
    print ActionStatus::COMPLETED
    print e.status_by_actions
    assert_equal ActionStatus::COMPLETED, e.status_by_actions

    e = events(:test_events_1)
    Aktion.create(:action_required=>"DELETED", :event => e, :action_status_id => ActionStatus::DELETED)
    Aktion.create(:action_required=>"DELETED2", :event => e, :action_status_id => ActionStatus::DELETED)
    assert_equal ActionStatus::DELETED, e.status_by_actions

    Aktion.create(:action_required=>"UNCOMLETED", :event => e, :action_status_id => ActionStatus::DELETED)
    assert_equal ActionStatus::DELETED, e.status_by_actions
    
    assert_equal ActionStatus::NO_LONGER_RELEVANT, e.status_by_actions
    assert_equal ActionStatus::COMPLETED, e.status_by_actions

  end

  def test_find_all_events_of_meeting
    assert_equal 0, Event.find_all_events_of_meeting(nil).size

    assert_equal 1, Event.find_all_events_of_meeting(events(:test_events_1)).size

    e = Event.new
    e.name ="TestEvents2"
    e.event_area = event_areas(:test_events_1)
    e.save

    es = Event.find_all_events_of_meeting(events(:test_events_1))
    assert_equal 2, es.size
    assert_equal "TestEvents1", es[0].name
    assert_equal "TestEvents2", es[1].name

  end

  def no_test_priorities
    e = events(:test_events_1)

    assert_equal nil, e.priority_value_by_axis(nil)
    assert_equal nil, e.priority_value_by_axis(PriorityAxis.find(priority_axes(:probability).id))

    print PriorityAxis.find(priority_axes(:probability).id).to_yaml
    print e.priority_value_by_axis(PriorityAxis.find(priority_axes(:probability).id)).to_yaml
    print e.priority_value_by_axis(priority_axes(:probability)).to_yaml
    
    prios =  {"priority_axis_#{priority_axes(:probability).id}" => priority_ranges(:one).value,
      "priority_axis_#{priority_axes(:severity).id}" => priority_ranges(:six).value}
    e.assign_priorities(prios, "description")
    assert_equal priority_ranges(:one), e.priority_value_by_axis(priority_axes(:probability))
    assert_equal priority_ranges(:six), e.priority_value_by_axis(priority_axes(:severity))
  end
end
