class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :confirm]
  before_filter :require_user, :only => [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration completed!"
      redirect_to root_url
    else
      render :action => :new
    end
  end

  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end

  def confirm
    @user = User.find_using_perishable_token(params[:token])

    if @user
      @user.send(:confirm!)
      UserSession.create(@user)

      flash[:notice] = "Account confirmed!"
      redirect_to account_url
    else
      redirect_to root_url
    end
  end
end
