# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    current_user.likes.find_or_create_by(post: @post)
    redirect_back_or_to(post_path(@post))
  end

  def destroy
    current_user.likes.find_by(post: @post)&.destroy
    redirect_back_or_to(post_path(@post))
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
