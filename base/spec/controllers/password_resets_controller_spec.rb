require File.expand_path(File.dirname(__FILE__) + '/../spec_helper' )
include SpecControllerHelper

describe PasswordResetsController do
  describe "new" do

    it_should_behave_like "an action that requires logged out user"

    before(:each) do
      @action = :new
    end
  end
end
