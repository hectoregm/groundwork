class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user)

    # Easy confirmation URL for testing in the browser
    if RAILS_ENV == "development"
      ActiveRecord::Base.logger.debug "\nCopy & Paste Confirmation:\nlocalhost:3000/" +
        "account/confirm?locale=#{I18n.locale.to_s}&token=#{user.perishable_token}\n\n"
    end
  end

  def after_save(user)
    UserMailer.deliver_activation(user) if user.recently_confirmed?
  end
end
