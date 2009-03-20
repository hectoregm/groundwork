require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module SpecControllerHelper

  shared_examples_for "an action that requires logged out user" do

    describe "requires logged out user" do
      it "should not be successful with logged in user" do
        log_user :login => "hector"
        get @action
        response.should_not be_success
      end

      it "should redirect to account with logged in user" do
        log_user :login => "hector"
        get @action
        should redirect_to(account_url)
      end

      it "should have /must be logged out/ in the flash with logged in user" do
        log_user :login => "hector"
        get @action
        should set_the_flash(:to => /must be logged out/)
      end

    end

  end

  shared_examples_for "an action that requires logged in user" do

    describe "requires logged in user" do
      it "should not be successful with logged out user" do
        get @action
        response.should_not be_success
      end

      it "should redirect to login page with logged out user" do
        get @action
        should redirect_to(new_user_session_url)
      end

      it "should have /must be logged in/ in the flash with logged out user" do
        get @action
        should set_the_flash(:to => /must be logged in/)
      end

    end

  end

end
