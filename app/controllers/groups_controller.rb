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
    group = user.groups.create!(params[:group].merge({owner_id: user.id, admin_ids: [user.id]}))
    redirect_to group
  end

  def edit
    @group = Group.find(params[:id])

    @memberSelect = [[@group.owner.getFullName, @group.owner.id]]
    @group.users.each do |user|
      unless @group.owner == user
        @memberSelect.push ([user.getFullName, user.id])
      end
    end
  end

  def update
    group = Group.find(params[:id])
    if params[:join]
      group.users << current_user
    elsif params[:leave]
      leave_group group
    else
      update_group group, params[:group]

    end
    redirect_to group
  end

  def destroy
    Group.find(params[:id]).destroy
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
      unless params[:own_ok] == "1"
        new_data.delete :owner_id
      else
        flash[:notice] = I18n.t "group.edit.owner"

      end

      group.attributes = new_data
      group.save
  end

end

