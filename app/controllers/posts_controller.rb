class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_post!, only: %i[edit update destroy]

  def index
    @posts = Post.includes(:likes, :tags, image_attachment: :blob, user: [avatar_attachment: :blob]).order(created_at: :desc)

    return if params[:tag].blank?

    @posts = @posts.joins(:tags).where(tags: { name: params[:tag] }).distinct
  end

  def show
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      @post.save_tags!(params.dig(:post, :tag_names))
      redirect_to posts_path, notice: t('flash.posts.created')
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @post.update(post_params)
      @post.save_tags!(params.dig(:post, :tag_names))
      redirect_to @post, notice: t('flash.posts.updated')
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: t('flash.posts.deleted')
  end

  private

  def set_post
  @post = Post.includes(:tags, :likes, image_attachment: :blob, user: [avatar_attachment: :blob], comments: :user).find_by!(uuid: params[:uuid])
  end

  def authorize_post!
    redirect_to posts_path, alert: t('flash.posts.forbidden') unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:content, :image, :worn_on, :temperature, :weather, :scene)
  end
end
