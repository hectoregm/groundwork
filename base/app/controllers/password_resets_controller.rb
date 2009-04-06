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
      flash[:notice] = t :reset_successful
      redirect_to root_url
    else
      flash.now[:error] = t :reset_unsuccessful
      render :new
    end
  end

  def edit
  end

  def update
    @user.validate_password = true
    if @user.update_attributes(params[:user])
      flash[:notice] = t :password_update_successful
      redirect_to account_url
    else
      render :edit
    end
  end

  private
  def load_user_with_token
    @user = User.find_using_perishable_token(params[:token])
    unless @user
      flash[:error] = t :invalid_reset_token
      redirect_to root_url
    end
  end

end
