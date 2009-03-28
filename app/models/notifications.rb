class Notifications < ActionMailer::Base
  
  def daily_digest_dashboard(user, meeting, server_path, meeting_summary, sent_at = Time.now)
    subject    "[ActionLog] Daily Digest of meeting #{meeting.name} from #{Time.now.to_date}"
    recipients user.email
    from       'info@firstprinciplesmanagement.com'
    sent_on    sent_at
    bcc        "watchdog@firstprinciplesmanagement.com"
    
    body       :user => user, :meeting => meeting, :server_path => server_path, :meeting_summary => meeting_summary
  end

end
