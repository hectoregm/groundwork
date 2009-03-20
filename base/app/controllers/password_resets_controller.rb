class PasswordResetsController < ApplicationController
  before_filter :require_no_user
  
  def new
  end
end
