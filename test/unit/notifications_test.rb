require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  test "daily_digest_dashboard" do
    @expected.subject = 'Notifications#daily_digest_dashboard'
    @expected.body    = read_fixture('daily_digest_dashboard')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notifications.create_daily_digest_dashboard(@expected.date).encoded
  end

end
