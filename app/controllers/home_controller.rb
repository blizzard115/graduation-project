class HomeController < ApplicationController
  def index
    @latest_posts = Post.includes(:user, image_attachment: :blob).order(created_at: :desc).limit(12)
  end
end
