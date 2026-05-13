class UsersController < ApplicationController
  before_action :set_user, only: %i[show likes following followers]

  def show
    @posts = @user.posts.includes(
      :likes,
      :tags,
      image_attachment: :blob,
      user: [avatar_attachment: :blob]
    ).order(created_at: :desc)
  end

  def likes
    @posts = Post
             .joins(:likes)
             .where(likes: { user_id: @user.id })
             .includes(
               :likes,
               :tags,
               image_attachment: :blob,
               user: [avatar_attachment: :blob]
             )
             .order('likes.created_at DESC')
  end

  def following
    @users = @user.following.includes(avatar_attachment: :blob)
    set_following_relationships
  end

  def followers
    @users = @user.followers.includes(avatar_attachment: :blob)
    set_following_relationships
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_following_relationships
    return unless user_signed_in?

    @following_relationships =
      current_user
      .active_relationships
      .where(followed_id: @users.ids)
      .index_by(&:followed_id)
  end
end
