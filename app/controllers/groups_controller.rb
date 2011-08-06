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

  end

  def update
    group = Group.find(params[:id])
    if params[:join]
      group.users << current_user
    end
    redirect_to group
  end

  def destroy
  end

end

