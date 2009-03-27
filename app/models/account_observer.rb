class AccountObserver < ActiveRecord::Observer
  def after_create(account)
    AccountMailer.deliver_signup_notification(account)
  end

  def after_save(account)
    if account.recently_activated? && account.user != nil && account.user.public_user
      AccountMailer.deliver_activation(account)
    end
  end
end
