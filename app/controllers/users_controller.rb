class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end

  def likes
    @user = User.find(params[:id])

    # いいねした投稿を新しい順で表示（N+1回避）
    @posts = Post
      .joins(:likes)
      .where(likes: { user_id: @user.id })
      .includes(:user, image_attachment: :blob)
      .order("likes.created_at DESC")
  end
end
