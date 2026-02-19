class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_back fallback_location: user_path(user)
  end

  def destroy
    relationship = current_user.active_relationships.find(params[:id])
    user = relationship.followed
    relationship.destroy
    redirect_back fallback_location: user_path(user)
  end
end
