module Authentication
  module SpecHelpers

    private
    # Creates a new confirmed user with an active session
    def log_user(attributes = {})
      user = User.make(attributes)
      user.send(:confirm!)
      set_session_for(user)
      user
    end

    # Mocks a User model
    def mock_user(stubs={})
      @mock_user ||= mock_model(User, stubs)
    end

    # Mocks a UserSession model
    def mock_user_session(stubs={})
      @mock_user_session ||= mock_model(UserSession, stubs)
    end

    # Mocks a login session for a mock user
    def mock_log_user(user)
      UserSession.stub!(:find).and_return(mock_user_session)
      mock_user_session.stub!(:user).and_return(user)
    end

  end

end
