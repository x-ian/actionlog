class AccountsController < ApplicationController  

  # render new.rhtml
  def new
    @account = Account.new
  end
 
  def create
    logout_keeping_session!
    @account = Account.new(params[:account])
    success = @account && @account.save
    if success && @account.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_account = @account # !! now logged in
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
end
