require File.expand_path(File.dirname(__FILE__) + '/../spec_helper' )
include SpecControllerHelper

describe UsersController do

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  describe "GET new" do

    it_should_behave_like "an action that requires logged out user"

    before(:each) do
      @action = :new
    end

    it "should initialize a new user" do
      User.should_receive(:new).and_return(mock_user)
      get :new
      should assign_to(:user, :with => mock_user)
    end

    it do
      get :new
      should render_template(:new)
    end

  end

  describe "GET edit" do

    it_should_behave_like "an action that requires logged in user"

    before(:each) do
      @action = :edit
    end

    it "should grab account information" do
      user = log_user :login => "hector"
      get :edit
      should assign_to(:user, :with => user)
    end

    it do
      log_user :login => "hector"
      get :edit
      should render_template(:edit)
    end

  end

  describe "POST create" do

    it_should_behave_like "an action that requires logged out user"

    before(:each) do
      @action = :create
    end

    describe "with valid input" do

      before(:each) do
        @attributes = User.plan
        @user = mock_user(@attributes.merge(:save => true))
      end

      it "should complete registration" do
        User.should_receive(:new).and_return(@user)

        post :create, :user => @attributes
        should assign_to(:user, :with => @user)
      end

      it "should redirect to homepage" do
        User.should_receive(:new).and_return(@user)

        post :create, :user => @attributes
        should redirect_to(root_url())
      end

      it do
        User.should_receive(:new).and_return(@user)

        post :create, :user => @attributes
        should set_the_flash(/completed!/)
      end

      it do
        User.should_receive(:new).and_return(@user)

        post :create, :user => @attributes
        should filter_params(:password, :password_confirmation)
      end
    end

    describe "with invalid input" do

      before(:each) do
        @attributes = User.plan
        @user = mock_user(@attributes.merge({:save => false, :valid? => false}))
      end

      it "should not create new user" do
        User.should_receive(:new).and_return(@user)

        post :create, :user => @attributes
        should assign_to(:user, :with => @user)
        assigns[:user].should_not be_valid
      end

      it "re-render the registration form" do
        User.should_receive(:new).and_return(@user)

        post :create, :user => @attributes
        should render_template('new')
      end

    end

  end

  describe "GET show" do

    it_should_behave_like "an action that requires logged in user"

    before(:each) do
      @action = :show
    end

    it "should get account information" do
      user = log_user :login => "hector"
      get :show
      should assign_to(:user, :with => user)
    end

    it do
      log_user :login => "hector"
      get :show
      should render_template(:show)
    end

  end

  describe "PUT update" do

    it_should_behave_like "an action that requires logged in user"

    before(:each) do
      @action = :update
    end

    describe "with valid input" do

      before(:each) do
        @user = log_user :login => "hector"
      end

      it "should update account information" do
        put :update

        should assign_to(:user, :with => @user)
        assigns[:user].should be_valid
      end

      it do
        put :update
        should redirect_to(account_url)
      end

      it do
        put :update
        should set_the_flash(/updated!/)
      end

      it do
        put :update
        should filter_params(:password, :password_confirmation)
      end

    end

    describe "with invalid input" do

      before(:each) do
        @user = log_user :login => "hector"
      end

      it "should not update account information" do
        put :update, :user => {:login => nil}
        should assign_to(:user)

        assigns[:user].should_not be_valid
      end

      it "re-render the account update form" do
        put :update, :user => {:login => nil}
        should render_template('edit')
      end

    end

  end

  describe "GET confirm" do

    it_should_behave_like "an action that requires logged out user"

    before(:each) do
      @action = :new
    end

    describe "with valid token" do
      before(:each) do
        @user = User.make
      end

      it "should confirm user" do
        User.should_receive(:find_using_perishable_token).
          with(@user.perishable_token).and_return(@user)

        get :confirm, :token => @user.perishable_token
      end

      it "should be logged in" do
        UserSession.should_receive(:create).with(@user)
        get :confirm, :token => @user.perishable_token
      end

    end

    describe "with invalid token" do

      before(:each) do
        @user = User.make
      end

      it "should not confirm user" do
        UserSession.should_not_receive(:create)
        get :confirm, :token => {}
      end

    end
  end

end
