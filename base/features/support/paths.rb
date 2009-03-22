module NavigationHelpers
  def path_to(page_name)
    case page_name

    when /the homepage/i
      root_path

    when /the registration form/i
      new_account_path

    when /the account page/i
      account_path

    when /the confirm page with bad token/
      confirm_account_path

    when /the login page/
      login_path
    when /the reset password page/
      new_password_reset_path

    when /the change password form with bad token/
      edit_password_reset_path

    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    end
  end
end

World do |world|
  world.extend NavigationHelpers
  world
end
