require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  before(:each) do
    @user = User.new
  end

  it "should be valid" do
    @user.attributes = User.plan
    @user.should be_valid
  end

  it "should require an email" do
    @user.attributes = User.plan(:email => nil)
    @user.should have(2).error_on(:email)
  end

  it "should require a login" do
    @user.attributes = User.plan(:login => nil)
    @user.should have(2).error_on(:login)
  end

  it "should require password" do
    @user.attributes = User.plan(:password => nil)
    @user.should have(1).error_on(:password)
  end

  it "should require password confirmation" do
    @user.attributes = User.plan(:password_confirmation => nil)
    @user.should have(1).error_on(:password_confirmation)
  end

end
