class Notifications < ActionMailer::Base
  
  def daily_digest_dashboard(user, meeting, server_path, meeting_summary, sent_at = Time.now)
    subject    "Daily Digest Dashboard of meeting #{meeting.name} from #{Time.now.to_date}"
    recipients user.email
    from       'christian.neumann@gmail.com'
    sent_on    sent_at
    
    body       :user => user, :meeting => meeting, :server_path => server_path, :meeting_summary => meeting_summary
  end

end
