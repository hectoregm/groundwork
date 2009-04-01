require File.expand_path(File.dirname(__FILE__) + '/../spec_helper' )

describe UsersController do

  describe "new:" do

    it_should_behave_like "an action that requires logged out user"

    before(:each) do
      User.stub!(:new).and_return(mock_user)
    end


    it "should initialize a new user" do
      User.should_receive(:new).and_return(mock_user)
      get :new
      should assign_to(:user, :with => mock_user)
    end

    it "should render the registration form" do
      get :new
      should render_template(:new)
    end

  end

  describe "edit:" do

    it_should_behave_like "an action that requires logged in user"

    before(:each) do
      mock_log_user(mock_user)
    end

    it "should grab account information" do
      get :edit
      should assign_to(:user, :with => mock_user)
    end

    it "should render edit form" do
      get :edit
      should render_template(:edit)
    end

  end

  describe "create:" do

    it_should_behave_like "an action that requires logged out user"

    context "With valid input" do

      before(:each) do
        mock_user(:save => true)
        User.stub!(:new).and_return(mock_user)
      end

      it "should complete registration" do
        User.should_receive(:new).and_return(mock_user)
        mock_user.should_receive(:save).and_return(true)

        post :create, :user => {}
        should assign_to(:user, :with => mock_user)
      end

      it "should redirect to homepage" do
        post :create, :user => {}
        should redirect_to(root_url())
      end

      it "should be successful" do
        post :create, :user => {}
        should set_the_flash(:to => /completed!/)
      end

      it do
        post :create, :user => {}
        should filter_params(:password, :password_confirmation)
      end
    end

    context "With invalid input" do

      before(:each) do
        mock_user(:save => false)
        User.stub!(:new).and_return(mock_user)
      end

      it "should re-render the registration form" do
        User.should_receive(:new).and_return(mock_user)
        mock_user.should_receive(:save).and_return(false)

        post :create, :user => {}
        should render_template(:new)
      end

      it "should not be successful" do
        post :create, :user => {}
        should_not set_the_flash(:to => /completed!/)
      end

    end

  end

  describe "show:" do

    it_should_behave_like "an action that requires logged in user"

    before(:each) do
      mock_log_user(mock_user)
    end

    it "should get account information" do
      get :show
      should assign_to(:user, :with => mock_user)
    end

    it "should render account information" do
      get :show
      should render_template(:show)
    end

  end

  describe "update:" do

    it_should_behave_like "an action that requires logged in user"

    context "With valid input" do

      before(:each) do
        mock_user(:update_attributes => true)
        mock_log_user(mock_user)
      end

      it "should update account information" do
        mock_user.should_receive(:update_attributes).and_return(true)

        put :update
        should assign_to(:user, :with => mock_user)
      end

      it "should redirect to account page" do
        put :update
        should redirect_to(account_url)
      end

      it "should be successful" do
        put :update
        should set_the_flash(:to => /updated!/)
      end

      it do
        put :update
        should filter_params(:password, :password_confirmation)
      end

    end

    context "With invalid input" do

      before(:each) do
        mock_user(:update_attributes => false)
        mock_log_user(mock_user)
      end

      it "should not update account information" do
        mock_user.should_receive(:update_attributes).and_return(false)
        put :update, :user => {}

        should assign_to(:user, :with => mock_user)
      end

      it "should re-render the account update form" do
        put :update, :user => {}
        should render_template(:edit)
      end

      it "should not be successful" do
        put :update, :user => {}
        should_not set_the_flash(:to => /updated!/)
      end

    end

  end

  describe "confirm:" do

    it_should_behave_like "an action that requires logged out user"

    context "With valid token" do

      before(:each) do
        User.stub!(:find_using_perishable_token).and_return(mock_user)
        mock_user.stub!(:confirm!)
        UserSession.stub!(:create)
      end

      it "should confirm user" do
        User.should_receive(:find_using_perishable_token).and_return(mock_user)
        mock_user.should_receive(:confirm!)

        get :confirm, :token => {}
        should assign_to(:user, :with => mock_user)
      end

      it "should be logged in" do
        UserSession.should_receive(:create).with(mock_user)

        get :confirm, :token => {}
      end

      it "should redirect to account page" do
        get :confirm, :token => {}
        should redirect_to(account_url)
      end

      it "should be successful" do
        get :confirm, :token => {}
        should set_the_flash(:to => /Account confirmed!/)
      end

    end

    context "With invalid token" do

      before(:each) do
        User.stub!(:find_using_perishable_token).and_return(nil)
      end

      it "should redirect to homepage" do
        get :confirm, :token => {}
        should redirect_to(root_url)
      end

      it "should not be successful" do
        User.should_receive(:find_using_perishable_token).and_return(nil)
        UserSession.should_not_receive(:create)

        get :confirm, :token => {}
        should set_the_flash(:to => /Account couldn't be confirmed/)
      end

    end

  end

end
