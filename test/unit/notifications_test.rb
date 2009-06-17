require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  test "daily_digest_dashboard" do
    user = User.find_by_name("Superuser")
    meeting = Meeting.find_by_name("FpmMeeting1")
    server_path = "abc"
    meeting_summary = ValueObjectMeetingSummary.new
    meeting_summary.completed_actions = 2
    meeting_summary.completed_actions_today = 2
    meeting_summary.completed_actions_by_user = 2
    meeting_summary.uncompleted_actions = 2

    @expected.subject = "[ActionLog] Daily Digest of meeting #{meeting.name} from #{Time.now.to_date}"
    @expected.body    = read_fixture('daily_digest_dashboard')
    @expected.date    = Time.now
    @expected.to = user.email
    @expected.from = 'info@firstprinciplesmanagement.com'
    @expected.bcc = "watchdog@firstprinciplesmanagement.com"

    a = Notifications.create_daily_digest_dashboard(user, meeting, server_path, meeting_summary)
    assert a.encoded.starts_with?(@expected.encoded)
  end

  def read_fixture(action)
    a = super
    template = ERB.new(a.join)
    template.result(binding)
  end

end
