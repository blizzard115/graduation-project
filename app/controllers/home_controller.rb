class HomeController < ApplicationController
  def index
    @latest_posts = Post.includes(:user, image_attachment: :blob).order(created_at: :desc).limit(12)
    @collage_posts = @latest_posts.take(3)
  end
end
