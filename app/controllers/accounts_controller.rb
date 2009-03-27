class AccountsController < ApplicationController  

  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_account, :only => [:suspend, :unsuspend, :destroy, :purge]


  # render new.rhtml
  def new
    @account = Account.new
  end

  def create
    logout_keeping_session!
    @account = Account.new(params[:account])
    @account.pw =params[:account][:password]
    @account.register! if @account && @account.valid?
    success = @account && @account.valid?
    if success && @account.errors.empty?
      redirect_to(login_url)
      #redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please correct the errors and try again."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    account = Account.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && account && !account.active?
      account.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      # success, create user
      user = User.new
      user.initialize_default_public_user_data(account)
      user.save
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_to(login_url)
      #redirect_back_or_default('/')
    else
      flash[:error]  = "We couldn't find a account with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_to(login_url)
      #redirect_back_or_default('/')
    end
  end

  def suspend
    @account.suspend!
    redirect_to accounts_path
  end

  def unsuspend
    @account.unsuspend!
    redirect_to accounts_path
  end

  def destroy
    @account.delete!
    redirect_to accounts_path
  end

  def purge
    @account.destroy
    redirect_to accounts_path
  end

  # There's no page here to update or destroy a account.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

  protected
  def find_account
    @account = Account.find(params[:id])
  end
end
