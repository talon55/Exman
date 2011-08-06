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

  def isOwner? user, group
    user.id == group.owner.id
  end

  def isAdmin? user, group
    group.admin_ids.include?(user.id)
  end

  def greeting user
    unless user.blank?
      "Hello, #{getFullName(current_user)}!"
    else
      "Hello!"
    end
  end
end

