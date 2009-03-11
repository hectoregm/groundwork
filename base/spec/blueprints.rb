Sham.login { InternetForgery.user_name }
Sham.password { BasicForgery.password }

User.blueprint do
  pwd = Sham.password
  login
  password { pwd }
  password_confirmation { pwd }
end
