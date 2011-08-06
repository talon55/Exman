class UsersController < ApplicationController

  before_filter :authenticate_user!

  def show
   @user = User.find(params[:id])
   #@groups = Group.where(user_ids: @user.id)
  end

end

