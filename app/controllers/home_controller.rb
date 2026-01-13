class HomeController < ApplicationController
  def index
    @latest_posts = Post.includes(:user).with_attached_image.order(created_at: :desc).limit(4)
  end
end
