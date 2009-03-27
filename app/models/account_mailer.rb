class AccountMailer < ActionMailer::Base

 helper :application
  def signup_notification(account)
    setup_email(account)
    @subject    += 'Please activate your new account'
    @body[:url]  = "#{APP_CONFIG['server_address']}/activate/#{account.activation_code}"
  
  end
  
  def activation(account)
    setup_email(account)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "#{APP_CONFIG['server_address']}"
  end
  
  protected
    def setup_email(account)
      @recipients  = "#{account.email}"
      @from        = "ADMINEMAIL"
      @subject     = "[ActionLog] "
      @sent_on     = Time.now
      @body[:account] = account
    end
end
