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
    else

    end
    redirect_to group
  end

  def destroy
    logger.debug("\n#{current_user.groups.to_a}\n")
    group = Group.find(params[:id])
    #group.users.each do |user|
    #  user.groups.delete_all(conditions: {_id: group.id})
    #end
    logger.debug("\n#{group.to_a}\n")
    group.destroy
    group.save
    logger.debug("\n#{group.to_a}\n")
    logger.debug("\n#{current_user.groups.to_a}\n")
    redirect_to root_path
  end

end

