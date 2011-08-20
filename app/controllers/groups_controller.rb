class GroupsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def create
    user = current_user
    group = user.groups.create!(params[:group].merge({owner_id: user.id}))
    redirect_to group
  end

  def edit
    @group = Group.find(params[:id])

    if (current_user.isOwner?(@group) || current_user.isAdmin?(@group))
      @ownerSelect = [[@group.owner.getFullName, @group.owner.id]]
      @group.users.each do |user|
         @ownerSelect.push ([user.getFullName, user.id])
      end
      @ownerSelect.uniq!

      @adminSelect = (@group.users - [@group.owner]).reverse!#.sort! {|a,b| }
    else
      flash[:alert] = I18n.t "group.failure.edit"
      redirect_to @group
    end
  end

  def update
    group = Group.find(params[:id])
    if params[:join]
      group.users << current_user
    elsif params[:leave]
      leave_group group
    elsif current_user.isAdmin? group
      update_group group, params[:group]
    else
      flash[:alert] = I18n.t "group.failure.edit"
    end
    redirect_to group
  end

  def destroy
    group = Group.find(params[:id])
    if current_user.isOwner? group
      group.destroy
    else
      flash[:alert] = I18n.t "group.failure.destroy"
    end
    redirect_to root_path
  end

  private

  def leave_group group
    if group.isSafeToLeave? current_user
      current_user.remove_group group
    else
      flash[:alert] = I18n.t("group.failure.is_owner")
    end
  end

  def update_group group, new_data
    note = nil
    # logger.debug new_data[:admin_ids].class is an Array

    group.name = new_data[:name] unless new_data[:name].blank?

    if params[:own_ok] == "1" && current_user.isOwner?(group)
      group.owner = new_data[:owner_id]
      note = "owner"
    end

    if current_user.isOwner?(group) && params[:adm_ok] == "1"
      group.admins = new_data[:admin_ids].reject {|item| item == "0"}
      note ||= "admin"
    end

#    unless (params[:own_ok] == "1") && current_user.isOwner?(group)
#      new_data.delete :owner_id
#    else
#      user = User.find new_data[:owner_id]
#      group.admin_ids.push(user.id).uniq!
#      note = "owner"
#    end
#    group.attributes = new_data
    group.save
    note ||= "success"
    flash[:notice] = I18n.t "group.edit.#{note}"
  end

end

