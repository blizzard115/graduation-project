# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Like do
  it 'is valid with a factory' do
    like = build(:like)
    expect(like).to be_valid
  end

  it 'is invalid without a user' do
    like = build(:like, user: nil)
    expect(like).not_to be_valid
  end

  it 'is invalid without a post' do
    like = build(:like, post: nil)
    expect(like).not_to be_valid
  end

  it 'does not allow duplicate likes for the same user and post' do
    like = create(:like)
    dup  = build(:like, user: like.user, post: like.post)
    expect(dup).not_to be_valid
  end
end
