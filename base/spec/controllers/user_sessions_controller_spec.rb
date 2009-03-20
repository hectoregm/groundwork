require File.expand_path(File.dirname(__FILE__) + '/../spec_helper' )
include SpecControllerHelper

describe UserSessionsController do

  describe "new" do

    it_should_behave_like "an action that requires logged out user"

    before(:each) do
      @action = :new
      mock_user_session
    end

    it "should initialize a new session" do
      UserSession.should_receive(:find).and_return(nil)
      UserSession.should_receive(:new).and_return(mock_user_session)

      get :new
      should assign_to(:user_session)
    end

  end

  describe "create" do

    it_should_behave_like "an action that requires logged out user"

    before(:each) do
      mock_user_session
      @action = :create
    end

    describe "with valid credentials" do

      it "should create a session" do
        valid_credentials

        post :create, :user_session => {}
      end

      it do
        valid_credentials

        post :create, :user_session => {}
        should set_the_flash(:to => "Login successful!")
      end

      it "should redirect to account page" do
        valid_credentials

        post :create, :user_session => {}
        should redirect_to(account_url)
      end

      def valid_credentials
        UserSession.should_receive(:find).and_return(nil)
        UserSession.should_receive(:new).and_return(mock_user_session)
        mock_user_session.should_receive(:save).and_return(true)
      end
    end

    describe "invalid credentials" do

      it "should not create a session" do
        invalid_credentials

        post :create, :user_session => {}
        should assign_to(:user_session, :with => mock_user_session)
      end

      it do
        invalid_credentials

        post :create, :user_session => {}
        should render_template('new')
      end

      it do
        invalid_credentials

        post :create, :user_session => {}
        should_not set_the_flash(:to => 'Login successful!')
      end

      def invalid_credentials
        UserSession.should_receive(:find).and_return(nil)
        UserSession.should_receive(:new).and_return(mock_user_session)
        mock_user_session.should_receive(:save).and_return(false)
      end

    end

  end

  describe "destroy" do

    it_should_behave_like "an action that requires logged in user"

    before(:each) do
      @action = :destroy
    end

    it "should destroy the session" do
      common_behavior

      post :destroy
    end

    it do
      common_behavior

      post :destroy
      should set_the_flash(:to => 'Logout successful!')
    end

    it "should redirect to login page" do
      common_behavior

      post :destroy
      should redirect_to(login_url)
    end

    def common_behavior
      UserSession.should_receive(:find).and_return(mock_user_session)
      mock_user_session.should_receive(:user).and_return(mock_user)
      mock_user_session.should_receive(:destroy)
    end
  end

end
