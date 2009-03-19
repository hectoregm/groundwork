ActionController::Routing::Routes.draw do |map|
  map.root :controller => "user_sessions", :action => "new"
  map.login '/login', :controller => "user_sessions", :action => "new"
  map.logout '/logout', :controller => "user_sessions", :action => "destroy"

  map.resource :account, :controller => "users", :member => { :confirm => :get }
  map.resource :user_session, :users
  map.resources :users
end
