# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes(
      :likes,
      :tags,
      image_attachment: :blob,
      user: [avatar_attachment: :blob]
    ).order(created_at: :desc)
  end

  def likes
    @user = User.find(params[:id])

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
    @user = User.find(params[:id])
    @users = @user.following.includes(avatar_attachment: :blob)

    if user_signed_in?
      @following_relationships = current_user.active_relationships.where(followed_id: @users.map(&:id)).index_by(&:followed_id)
    end
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers.includes(avatar_attachment: :blob)

    if user_signed_in?
      @following_relationships = current_user.active_relationships.where(followed_id: @users.map(&:id)).index_by(&:followed_id)
    end
  end
end