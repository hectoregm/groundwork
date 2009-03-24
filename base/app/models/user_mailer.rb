# -*- coding: utf-8 -*-
class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject += 'Account Confirmation'
  end

  def activation(user)
    setup_email(user)
    @subject += 'Welcome'
  end

  def reset_password_instructions(user)
    setup_email(user)
    @subject += 'Password Reset'
  end

  protected
  def setup_email(user)
    recipients user.email
    from       "APP Notifications <notifications@example.com>"
    @subject   = "[APP] "
    sent_on    Time.now
    body :user => user
  end
end
