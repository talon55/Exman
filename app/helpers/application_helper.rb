module ApplicationHelper

  #def getFullName user
  #  unless user.blank?
  #    user.getFullName
  #  else
  #    nil
  #  end
  #end

  def userLink user
    link_to user.getFullName, user
  end

  def greeting user
    unless user.blank?
      "Hello, #{current_user.getFullName}!"
    else
      "Hello!"
    end
  end
end

