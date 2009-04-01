class PasswordResetsController < ApplicationController
  layout 'single_column'

  before_filter :require_no_user
  before_filter :load_user_with_token, :only => [:edit, :update]

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset!
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +
        "Please check your email."

      redirect_to root_url
    else
      flash.now[:error] = "No user was found with that email address"
      render :action => :new
    end
  end

  def edit
  end

  def update
    @user.validate_password = true
    if @user.update_attributes(params[:user])
      flash[:notice] = "Password successfully updated"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  private
  def load_user_with_token
    @user = User.find_using_perishable_token(params[:token])
    unless @user
      flash[:error] = "We're sorry, but we could not locate your account. " +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
      redirect_to root_url
    end
  end

end
