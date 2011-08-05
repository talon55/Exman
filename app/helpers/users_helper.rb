module UsersHelper

  def getFullName user
    "#{user.first_name.capitalize} #{user.last_name.capitalize}"
  end

end

