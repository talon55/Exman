module ApplicationHelper

  def userLink user
    link_to getFullName(user), user
  end

  def isOwner? user, group
    user.id == group.owner.id
  end

  def isAdmin? user, group
    group.admin.include?(user.id)
  end
end

