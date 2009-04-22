require File.expand_path(File.dirname(__FILE__) + '/../spec_helper' )

describe SessionsController do

  describe "new:" do

    it_should_behave_like "an action that requires logged out user"

    it "should create a new session" do
      UserSession.should_receive(:find).and_return(nil)
      UserSession.should_receive(:new).and_return(mock_user_session)

      get :new
      should assign_to(:session, :with => mock_user_session)
    end

    it "should render login form" do
      UserSession.stub!(:find).and_return(nil)
      UserSession.stub!(:new).and_return(mock_user_session)

      get :new
      should render_template(:new)
    end

  end

  describe "create:" do

    it_should_behave_like "an action that requires logged out user"

    context "Log in with valid credentials" do

      before(:each) do
        UserSession.stub!(:find => nil, :new => mock_user_session)
        mock_user_session.stub!(:save).and_return(true)
      end

      it "should create a session" do
        mock_user_session.should_receive(:save).and_return(true)

        post :create, :session => {}
        should assign_to(:session, :with => mock_user_session)
      end

      it "should redirect to account page" do
        post :create, :session => {}
        should redirect_to(account_url)
      end

      it "should be successful" do
        post :create, :session => {}
        should set_the_flash(:to => "Login successful!")
      end

    end

    context "Log in with invalid credentials" do

      before(:each) do
        UserSession.stub!(:find => nil, :new => mock_user_session)
        mock_user_session.stub!(:save).and_return(false)
        mock_user_session.errors.stub!(:on).and_return('Incorrect login or password')
      end

      it "should re-render login form" do
        post :create, :session => {}
        should render_template(:new)
      end

      it "should not be successful" do
        mock_user_session.should_receive(:save).and_return(false)

        post :create, :session => {}
        should_not set_the_flash(:to => 'Login successful!')
      end

    end

  end

  describe "destroy:" do

    it_should_behave_like "an action that requires logged in user"

    context "With user logged in" do

      before(:each) do
        UserSession.stub!(:find).and_return(mock_user_session)
        mock_user_session.stub!(:user).and_return(mock_user)
        mock_user_session.stub!(:destroy)
      end

      it "should destroy the session" do
        mock_user_session.should_receive(:destroy)

        delete :destroy
      end

      it "should redirect to login page" do
        delete :destroy
        should redirect_to(login_url)
      end

      it "should be successful" do
        delete :destroy
        should set_the_flash(:to => 'Logout successful!')
      end

    end

  end

end
