class TagsController < ApplicationController
  def show
    @tag_name = params[:name]
    @posts = Post.joins(:tags)
                 .where(tags: { name: @tag_name })
                 .includes(:user, image_attachment: :blob)
                 .order(created_at: :desc)
  end
end
