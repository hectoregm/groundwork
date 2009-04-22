class SessionsController < ApplicationController
  layout 'single_column'

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @session = UserSession.new
  end

  def create
    @session = UserSession.new(params[:user_session])
    if @session.save
      flash[:notice] = t :login_successful
      redirect_back_or_default account_url
    else
      message = @session.errors.on(:base) ? @session.errors.on(:base) : t(:login_unsuccessful)
      flash.now[:error] = message
      render :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = t :logout_successful
    redirect_back_or_default login_url
  end
end
