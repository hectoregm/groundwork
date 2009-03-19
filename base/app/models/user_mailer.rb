# -*- coding: utf-8 -*-
class UserMailer < ActionMailer::Base
  default_url_options[:host] = 'www.example.com'
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please confirm your account.'
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Welcome to app.'
  end

  def forgot_password(user)
    setup_email(user)
    @subject += 'You have asked to reset your password.'
    @body[:url] = "http://app#{DOMAIN}/reset_password/#{token}"
  end

  #FIXME: Reseteado es español?
  def reset_password(user)
    setup_email(user)
    @subject += 'Your password has been reset.'
  end

  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "admin@example.com"
      @subject     = "[APP] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
