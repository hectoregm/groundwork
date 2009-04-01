require File.expand_path(File.dirname(__FILE__) + '/../spec_helper' )

describe PasswordResetsController do

  describe "new:" do

    it_should_behave_like "an action that requires logged out user"

    it "should render the reset password form" do
      get :new
      should render_template(:new)
    end

  end

  describe "create:" do

    it_should_behave_like "an action that requires logged out user"

    context "Found user with the given email" do

      before(:each) do
        User.stub!(:find_by_email).with("mock@mail.com").and_return(mock_user)
        mock_user.stub!(:deliver_password_reset!)
      end

      it "should send email with reset instructions" do
        User.should_receive(:find_by_email).with("mock@mail.com").and_return(mock_user)
        mock_user.should_receive(:deliver_password_reset!)

        post :create, :email => "mock@mail.com"
        should assign_to(:user, :with => mock_user)
      end

      it "should redirect to homepage" do
        post :create, :email => "mock@mail.com"
        should redirect_to(root_url)
      end

      it "should be successful" do
        post :create, :email => "mock@mail.com"
        should set_the_flash(:to => /Instructions to reset your password/)
      end

    end

    context "Couldn't found user with given email" do

      before(:each) do
        User.stub!(:find_by_email).with("mock@mail.com").and_return(nil)
      end

      it "should not send email with reset instructions" do
        User.should_receive(:find_by_email).with("mock@mail.com").and_return(nil)

        post :create, :email => "mock@mail.com"
        should_not assign_to(:user)
      end

      it "should re-render the reset password form" do
        post :create, :email => "mock@mail.com"
        should render_template(:new)
      end

      it "should not be successful" do
        post :create, :email => "mock@mail.com"
        should render_template(:new)
      end

    end

  end

  describe "edit:" do

    it_should_behave_like "an action that requires logged out user"

    context "Found user with the given token" do

      it "should render the change password form" do
        User.should_receive(:find_using_perishable_token).with("validtoken").and_return(mock_user)
        get :edit, :token => "validtoken"
        should render_template(:edit)
      end

    end

    context "Couldn't found user with the given token" do

      before(:each) do
        User.stub!(:find_using_perishable_token).with("invalidtoken").and_return(nil)
      end

      it "should not render the change password form" do
        User.should_receive(:find_using_perishable_token).with("invalidtoken").and_return(nil)
        get :edit, :token => "invalidtoken"
        should_not render_template(:edit)
      end

      it "should redirect to homepage" do
        get :edit, :token => "invalidtoken"
        should redirect_to(root_url)
      end

      it "should not be successful "do
        get :edit, :token => "invalidtoken"
        should set_the_flash(:to => /sorry, but we could not locate your account/)
      end

    end

  end

  describe "update:" do

    it_should_behave_like "an action that requires logged out user"

    context "Found user with valid token" do

      context "and with valid input"do

        before(:each) do
          User.stub!(:find_using_perishable_token).with("validtoken").and_return(mock_user)
          mock_user.stub!(:validate_password= => true)
          mock_user.stub!(:update_attributes).and_return(true)
        end

        it "should update password" do
          User.should_receive(:find_using_perishable_token).with("validtoken").and_return(mock_user)
          mock_user.should_receive(:update_attributes).and_return(true)

          put :update, :token => "validtoken", :user => { }
          should assign_to(:user, :with => mock_user)
        end

        it "should redirect to account page" do
          put :update, :token => "validtoken", :user => { }
          should redirect_to(account_url)
        end

        it "should be successful" do
          put :update, :token => "validtoken", :user => { }
          should set_the_flash(:to => /Password successfully updated/)
        end

      end

      context "and with invalid input" do

        before(:each) do
          User.stub!(:find_using_perishable_token).with("validtoken").and_return(mock_user)
          mock_user.stub!(:validate_password= => true)
          mock_user.stub!(:update_attributes).and_return(false)
        end

        it "should not update password" do
          User.should_receive(:find_using_perishable_token).with("validtoken").and_return(mock_user)
          mock_user.should_receive(:update_attributes).and_return(false)

          put :update, :token => "validtoken", :user => { }
        end

        it "should re-render the change password form" do
          put :update, :token => "validtoken", :user => { }
          should render_template(:edit)
        end

        it "should not be successful" do
          put :update, :token => "validtoken", :user => { }
          should_not set_the_flash(:to => /Password successfully updated/)
        end

      end

    end

  end

end
