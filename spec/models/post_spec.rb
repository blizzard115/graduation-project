# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post do
  it 'is valid with a factory' do
    post = build(:post)
    expect(post).to be_valid
  end

  it 'returns likes count' do
    post = create(:post)
    create_list(:like, 3, post: post)
    expect(post.likes_count).to eq(3)
  end
end
