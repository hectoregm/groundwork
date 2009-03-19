class User < ActiveRecord::Base
  acts_as_authentic

  def recent_confirmation?
    @recent_confirmation
  end

  private
  def confirm!
    self.update_attribute(:confirmed, true)
    @recent_confirmation = true
  end
end
