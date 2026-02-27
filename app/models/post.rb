# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :content, presence: true, length: { maximum: 1000 }
  validate :image_presence

  has_many :likes, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy

  attr_accessor :tag_names

  def save_tags!(names)
    tag_list = names.to_s.split(',').map { |t| t.strip.downcase }.reject(&:blank?).uniq
    self.tags = tag_list.map { |n| Tag.find_or_create_by!(name: n) }
  end

  def likes_count
    likes.count
  end

  private

  def image_presence
    errors.add(:image, 'を選択してください') unless image.attached?
  end
end
