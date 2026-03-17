# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  has_many :likes, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags
  has_many :comments, dependent: :destroy

  enum :weather, {
    sunny: 0,
    cloudy: 1,
    rainy: 2,
    snowy: 3
  }

  enum :scene, {
    casual_outing: 0,
    commuting: 1,
    school: 2,
    date: 3,
    travel: 4,
    shopping: 5,
    cafe: 6,
    formal: 7
  }

  validates :content, presence: true, length: { maximum: 1000 }
  validates :worn_on, presence: true
  validates :weather, presence: true
  validates :scene, presence: true
  validates :temperature,
            numericality: { greater_than_or_equal_to: -20, less_than_or_equal_to: 50 },
            allow_nil: true
  validate :image_presence

  attr_accessor :tag_names

    # 一覧（masonry）用：幅を抑えて比率維持（高さはバラバラでOK）
  def image_masonry
    image.variant(resize_to_limit: [600, 2000]
    )
  end

  # 詳細（show）用：少し大きめ
  def image_show
    image.variant(resize_to_limit: [1200, 3000]
    )
  end

  before_create :set_uuid

  def to_param
    uuid
  end

  def save_tags!(names)
    tag_list = names.to_s.split(',').map { |t| t.strip.downcase }.compact_blank.uniq
    self.tags = tag_list.map { |n| Tag.find_or_create_by!(name: n) }
  end

  def weather_i18n
    {
      "sunny" => "晴れ",
      "cloudy" => "くもり",
      "rainy" => "雨",
      "snowy" => "雪"
    }[weather]
  end

  def scene_i18n
    {
      "casual_outing" => "外出",
      "commuting" => "通勤",
      "school" => "通学",
      "date" => "デート",
      "travel" => "旅行",
      "shopping" => "買い物",
      "cafe" => "カフェ",
      "formal" => "フォーマル"
    }[scene]
  end

  after_initialize :set_defaults, if: :new_record?

  def set_defaults
    self.worn_on ||= Date.current
    self.weather ||= :sunny
    self.scene ||= :casual_outing
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