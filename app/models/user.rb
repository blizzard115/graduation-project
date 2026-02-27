# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  has_many :comments, dependent: :destroy
  has_one_attached :avatar

  # 自分が「フォローしている関係」
  has_many :active_relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy

  # 自分が「フォローされている関係」
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: :followed_id, dependent: :destroy

  # フォローしているユーザー一覧
  has_many :following, through: :active_relationships, source: :followed

  # フォローされているユーザー一覧
  has_many :followers, through: :passive_relationships, source: :follower

  def follow(other_user)
    return if self == other_user

    active_relationships.create(followed: other_user)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed: other_user)&.destroy
  end

  def following?(other_user)
    following.exists?(other_user.id)
  end
end
