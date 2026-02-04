class TagsController < ApplicationController
  def show
    @tag = Tag.find_by!(name: params[:name].to_s.downcase)
    @posts = @tag.posts.includes(:user, :tags, image_attachment: :blob).order(created_at: :desc)
  end
end
