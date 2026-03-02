# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to post_path(@post), notice: t('flash.comments.created')
    else
      @comments = @post.comments.order(created_at: :desc) # 再取得
      render 'posts/show', status: :unprocessable_content
    end
  end

  def destroy
    if @comment.user == current_user
      @comment.destroy
      redirect_to post_path(@post), notice: t('flash.comments.deleted')
    else
      redirect_to post_path(@post), alert: t('flash.comments.forbidden')
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
