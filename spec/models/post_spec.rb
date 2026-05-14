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

  it 'is invalid without content' do
    post = build(:post, content: nil)
    expect(post).not_to be_valid
  end

  it 'is invalid without worn_on' do
    post = build(:post, worn_on: nil)
    expect(post).not_to be_valid
  end

  it 'is invalid when temperature is too low' do
    post = build(:post, temperature: -21)
    expect(post).not_to be_valid
  end

  it 'is invalid when temperature is too high' do
    post = build(:post, temperature: 51)
    expect(post).not_to be_valid
  end

  it 'sets uuid before create' do
    post = create(:post)
    expect(post.uuid).to be_present
  end

  it 'uses uuid as to_param' do
    post = create(:post)
    expect(post.to_param).to eq(post.uuid)
  end
end
