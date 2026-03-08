class DeleteAllPosts < ActiveRecord::Migration[7.1]
  def up
    Comment.delete_all
    Like.delete_all
    PostTag.delete_all
    Post.delete_all
  end

  def down
  end
end
