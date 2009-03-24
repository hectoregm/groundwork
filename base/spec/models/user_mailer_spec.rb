require File.dirname(__FILE__) + '/../spec_helper'

describe "Signup Email" do
  include ActionController::UrlWriter

  before(:all) do
    mock_user(User.plan.merge(:perishable_token => 'validtoken'))
    @email = UserMailer.create_signup_notification(mock_user)
  end

  subject { @email }

  it "should be set to be delivered to the email of user." do
    should deliver_to(mock_user.email)
  end

  it "should contain some greeting text" do
    should have_text(/A new account was requested/)
  end

  it "should contain a link to confirm account" do
    should have_text(/#{confirm_account_url :host => 'www.example.com'}/)
  end

  it "should have the correct subject" do
    should have_subject(/Account Confirmation/)
  end

end

describe "Activation Email" do
  include ActionController::UrlWriter

  before(:all) do
    mock_user(User.plan)
    @email = UserMailer.create_activation(mock_user)
  end

  subject { @email }

  it "should be set to be delivered to the email of the user" do
    should deliver_to(mock_user.email)
  end

  it "should contain a brief thank you" do
    should have_text(/Thanks for using our service/)
  end

  it "should contain a link to the homepage" do
    should have_text(/#{root_url :host => 'www.example.com'}/)
  end

  it "should have the correct subject" do
    should have_subject(/Welcome/)
  end

end

describe "Reset Password Email" do
  include ActionController::UrlWriter

  before(:all) do
    mock_user(User.plan.merge(:perishable_token => 'validtoken'))
    @email = UserMailer.create_reset_password_instructions(mock_user)
  end

  subject { @email }

  it "should be set to be delivered to the email of the user" do
    should deliver_to(mock_user.email)
  end

  it "should contain the instructions to reset the password" do
    should have_text(/A request to reset your password/)
  end

  it "should contain a link to reset password" do
    should have_text(/#{edit_password_reset_url :host => 'www.example.com'}/)
  end

  it "should have the correct subject" do
    should have_subject(/Password Reset/)
  end

end
