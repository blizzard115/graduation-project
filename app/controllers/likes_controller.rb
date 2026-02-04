class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    current_user.likes.create!(post: @post)
    redirect_back fallback_location: post_path(@post)
  rescue ActiveRecord::RecordNotUnique
    redirect_back fallback_location: post_path(@post)
  end

  def destroy
    current_user.likes.find_by(post: @post)&.destroy
    redirect_back fallback_location: post_path(@post)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
