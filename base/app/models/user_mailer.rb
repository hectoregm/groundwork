# -*- coding: utf-8 -*-
class UserMailer < ActionMailer::Base
  default_url_options[:host] = 'www.example.com'

  def signup_notification(user)
    setup_email(user)
    @subject += 'Please confirm your account'
  end

  def activation(user)
    setup_email(user)
    @subject += 'Welcome'
  end

  def reset_password_instructions(user)
    setup_email(user)
    @subject += 'You have asked to reset your password.'
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
