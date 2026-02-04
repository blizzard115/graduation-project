class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  validates :image, presence: true 
  validates :content, presence: true, length: { maximum: 1000 }
  has_many :likes, dependent: :destroy

  def likes_count
    likes.count
  end
end
