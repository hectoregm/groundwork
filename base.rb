# base.rb
# from Hector E. Gomez M.
# based on bort template"

# Get rails edge code.
inside('vendor') do
  run "ln -s ~/Projects/github/rails rails"
end

# Remove tmp directories
["./tmp/pids", "./tmp/sessions", "./tmp/sockets", "./tmp/cache"].each do |f|
  run("rmdir ./#{f}")
end

# Delete unnecessary files.
%w{doc/README_FOR_APP public/index.html public/favicon.ico public/robots.txt}.each do |f|
  run("rm #{f}")
end

# Hold empty directories making a .gitignore file
run("find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;")

# Copy database.yml for distribution use
run "cp config/database.yml config/database.yml.example"

# Create  master .gitignore file
file '.gitignore', <<-CODE
.#*
*~
*#
config/database.yml
config/mongrel_cluster.yml
coverage
db/schema.rb
db/*.sqlite3
doc/api
doc/app
.DS_Store
log/*.log
log/*.pid
*.swp
tmp/**/*
vendor/rails
CODE

# Initialize git repository
git :init

# Add plugins.
# plugin 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git', :submodule => true

# Install gem'
#gem "dchelimsky-rspec", :lib => false, :version => "1.1.99.7"
#gem "dchelimsky-rspec-rails", :lib => false, :version => ">= 1.1.99.7"
gem "webrat"
gem "cucumber"
gem "authlogic"

# Send initial commit
#git :add => "."

#git :commit => "-a -m 'Setting up a new rails app.'"

# Authlogic step up
generate :session, "user_session"
generate :controller, "user_sessions"
generate :scaffold, "users", "login:string", "crypted_password:string",
"password_salt:string", "persistence_token:string", "login_count:integer",
"last_request_at:datetime", "last_login_at:datetime", "current_login_at:datetime",
"last_login_ip:string", "current_login_ip:string"

# Create routes for UserSession and Users (with Account singular alias)
route "map.resource :user_session, :users"
route "map.resource :account, :controller => \"users\""
route "map.root :controller => \"user_sessions\", :action => \"new\""

# Modify models
file 'app/models/user.rb', <<-CODE
class User < ActiveRecord::Base
  acts_as_authentic
end
CODE

# Modify controllers
file 'app/controllers/application_controller.rb', <<-CODE
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  private
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
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
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
end
CODE

file 'app/controllers/user_sessions_controller.rb', <<-CODE
class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
end
CODE

file 'app/controllers/users_controller.rb', <<-CODE
class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
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
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
CODE

# User views
file 'app/views/users/new.html.erb', <<-CODE
<h1>Register</h1>

<% form_for @user, :url => account_path do |f| %>
  <%= f.error_messages %>
  <%= render :partial => "form", :object => f %>
  <%= f.submit "Register" %>
<% end %>
CODE

file 'app/views/users/edit.html.erb', <<-CODE
<h1>Edit My Account</h1>

<% form_for @user, :url => account_path do |f| %>
  <%= f.error_messages %>
  <%= render :partial => "form", :object => f %>
  <%= f.submit "Update" %>
<% end %>

<br /><%= link_to "My Profile", account_path %>
CODE

file 'app/views/users/_form.erb', <<-CODE
<%= form.label :login %><br />
<%= form.text_field :login %><br />
<br />
<%= form.label :password, form.object.new_record? ? nil : "Change password" %><br />
<%= form.password_field :password %><br />
<br />
<%= form.label :password_confirmation %><br />
<%= form.password_field :password_confirmation %><br />
<br />
CODE

file 'app/views/users/show.html.erb', <<-CODE
<p>
  <b>Login:</b>
  <%=h @user.login %>
</p>

<p>
  <b>Login count:</b>
  <%=h @user.login_count %>
</p>

<p>
  <b>Last request at:</b>
  <%=h @user.last_request_at %>
</p>

<p>
  <b>Last login at:</b>
  <%=h @user.last_login_at %>
</p>

<p>
  <b>Current login at:</b>
  <%=h @user.current_login_at %>
</p>

<p>
  <b>Last login ip:</b>
  <%=h @user.last_login_ip %>
</p>

<p>
  <b>Current login ip:</b>
  <%=h @user.current_login_ip %>
</p>


<%= link_to 'Edit', edit_account_path %>
CODE

# Login view
file 'app/views/user_sessions/new.html.erb', <<-CODE
<h1>Login</h1>

<% form_for @user_session, :url => user_session_path do |f| %>
  <%= f.error_messages %>
  <%= f.label :login %><br />
  <%= f.text_field :login %><br />
  <br />
  <%= f.label :password %><br />
  <%= f.password_field :password %><br />
  <br />
  <%= f.check_box :remember_me %><%= f.label :remember_me %><br />
  <br />
  <%= f.submit "Login" %>
<% end %>
CODE

# Modify application layout
file 'app/views/layouts/application.html.erb', <<-CODE
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
  <meta http-equiv="content-type" content="text/html;charset=UTF-8" />
  <title><%= controller.controller_name %>: <%= controller.action_name %></title>
  <%= stylesheet_link_tag 'scaffold' %>
  <%= javascript_include_tag :defaults %>
</head>
<body>

<span style="float: right; text-align: right;"><%= link_to "Source code", "http://github.com/binarylogic/authlogic_example" %> | <%= link_to "Setup tutorial", "http://www.binarylogic.com/2008/11/3/tutorial-authlogic-basic-setup" %> | <%= link_to "Password reset tutorial", "http://www.binarylogic.com/2008/11/16/tutorial-reset-passwords-with-authlogic" %><br />
<%= link_to "OpenID tutorial", "http://www.binarylogic.com/2008/11/21/tutorial-using-openid-with-authlogic" %> | <%= link_to "Authlogic Repo", "http://github.com/binarylogic/authlogic" %> | <%= link_to "Authlogic Doc", "http://authlogic.rubyforge.org/" %></span>
<h1>Authlogic Example App</h1>
<%= pluralize User.logged_in.count, "user" %> currently logged in<br /> <!-- This based on last_request_at, if they were active < 10 minutes they are logged in -->
<br />
<br />


<% if !current_user %>
  <%= link_to "Register", new_account_path %> |
  <%= link_to "Log In", new_user_session_path %> |
<% else %>
  <%= link_to "My Account", account_path %> |
  <%= link_to "Logout", user_session_path, :method => :delete, :confirm => "Are you sure you want to logout?" %>
<% end %>

<p style="color: green"><%= flash[:notice] %></p>

<%= yield  %>

</body>
</html>
CODE

run 'rm app/views/layouts/users.html.erb'

# Create database
rake "db:migrate"
