class ApplicationController < ActionController::Base
  helper :all
  helper_method :current_user_session, :current_user, :default_url_options

  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation

  before_filter :set_locale

  private
  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless current_user
      # No redirect if requested page is /logout
      store_location if !(request.request_uri =~ /\/logout$/)
      flash[:error] = t :require_user
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:error] = t :require_no_user
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def set_locale
    I18n.locale = params[:locale]
  end
end
