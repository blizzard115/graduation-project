# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :likes, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy

  validates :content, presence: true, length: { maximum: 1000 }
  validate :image_presence

  attr_accessor :tag_names

  before_create :set_uuid

  def to_param
    uuid
  end

  def save_tags!(names)
    tag_list = names.to_s.split(',').map { |t| t.strip.downcase }.compact_blank.uniq
    self.tags = tag_list.map { |n| Tag.find_or_create_by!(name: n) }
  end

  delegate :count, to: :likes, prefix: true

  private

  def set_uuid
    self.uuid ||= SecureRandom.uuid
  end

  def image_presence
    errors.add(:image, 'を選択してください') unless image.attached?
  end
end