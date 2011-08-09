module ApplicationHelper

  def getFullName user
    unless user.blank?
      "#{user.first_name.capitalize} #{user.last_name.capitalize}"
    else
      nil
    end
  end

  def userLink user
    link_to getFullName(user), user
  end

  def greeting user
    unless user.blank?
      "Hello, #{getFullName(current_user)}!"
    else
      "Hello!"
    end
  end
end

