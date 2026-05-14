# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it 'is valid with a factory' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'follows another user' do
    user = create(:user)
    other_user = create(:user)

    user.follow(other_user)

    expect(user.following?(other_user)).to be true
  end

  it 'unfollows another user' do
    user = create(:user)
    other_user = create(:user)
    user.follow(other_user)

    user.unfollow(other_user)

    expect(user.following?(other_user)).to be false
  end

  it 'does not follow itself' do
    user = create(:user)

    expect do
      user.follow(user)
    end.not_to change(Relationship, :count)
  end
end
