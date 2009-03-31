class AccountObserver < ActiveRecord::Observer
  def after_create(account)
    if account.state == "pending"
      AccountMailer.deliver_signup_notification(account)
    end
  end

  def after_save(account)
    # TODO: why is the mail sent 3 times? deactivated for now
    #if account.recently_activated? && ((account.user != nil && account.user.public_user) || account.user == nil)
      #AccountMailer.deliver_activation(account)
    #end
  end
end
