# -*- coding: utf-8 -*-
class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject += I18n.t('user_mailer.signup_subject')
  end

  def activation(user)
    setup_email(user)
    @subject += I18n.t('user_mailer.activation_subject')
  end

  def reset_password_instructions(user)
    setup_email(user)
    @subject += I18n.t('user_mailer.reset_password_subject')
  end

  protected
  def setup_email(user)
    recipients user.email
    from       I18n.t('user_mailer.from', :email => '<notifications@example.com>')
    @subject   = "[APP] "
    sent_on    Time.now
    body :user => user
  end
end
