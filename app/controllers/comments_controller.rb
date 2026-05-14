# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:destroy]
  before_action :authorize_comment!, only: [:destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post), notice: t('flash.comments.created')
    else
      @comments = @post.comments.includes(:user).order(created_at: :desc)
      set_following_relationships_for([@post.user])
      render 'posts/show', status: :unprocessable_content
    end
  end

  def destroy
    @comment.destroy
    redirect_to post_path(@post), notice: t('flash.comments.deleted')
  end

  private

  def set_post
    @post = Post.find_by!(uuid: params[:post_uuid])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def authorize_comment!
    return if @comment.user == current_user
    redirect_to post_path(@post), alert: t('flash.comments.forbidden')
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
