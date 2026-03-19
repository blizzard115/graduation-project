# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    posts = Post.includes(:user, :tags, image_attachment: :blob)
            .order(created_at: :desc)

    @collage_posts = posts.limit(3)
    @preview_post  = posts.offset(3).first || posts.first
    @latest_posts  = posts.limit(12)
  end
end
