class User < ActiveRecord::Base
  acts_as_authentic

  private
  def confirm!
    self.update_attribute(:confirmed, true)
  end
end
