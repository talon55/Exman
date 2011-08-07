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
  end

  def update
    group = Group.find(params[:id])
    if params[:join]
      group.users << current_user
    elsif params[:leave]

    else
      group.attributes = params[:group]
      group.save
    end
    redirect_to group
  end

  def destroy
    Group.find(params[:id]).destroy
    redirect_to root_path
  end

  private

  def leave_group

  end

end

