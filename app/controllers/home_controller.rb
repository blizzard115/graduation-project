# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @latest_posts = Post
                    .includes(:user, image_attachment: :blob)
                    .with_attached_image
                    .order(created_at: :desc)
                    .limit(12)
    @collage_posts = @latest_posts.take(3)
  end
end
