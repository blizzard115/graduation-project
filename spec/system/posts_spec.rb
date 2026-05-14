# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post management' do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password, password_confirmation: password) }

  before do
    driven_by(:rack_test)

    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'ログイン'
  end

  it 'allows a user to create a post with an image' do
    visit new_post_path

    fill_in 'キャプション', with: 'My first outfit post'

    attach_file 'post_image',
                Rails.root.join('spec/fixtures/files/雪豹.png')

    click_button '投稿する'

    expect(page).to have_content('投稿しました')

    post = Post.order(:created_at).last
    expect(post.content).to eq('My first outfit post')
    expect(post.image).to be_attached
  end

  it 'allows a user to add a comment to a post' do
    post_record = create(:post)

    visit post_path(post_record)

    fill_in 'comment_content', with: '素敵なコーデです'
    click_button '送信'

    expect(page).to have_content('コメントを投稿しました')
    expect(page).to have_content('素敵なコーデです')
  end

  it 'allows a user to like a post' do
    post_record = create(:post)

    visit post_path(post_record)

    expect do
      find('.like-btn').click
    end.to change(Like, :count).by(1)

    expect(page).to have_content('1')
  end

  it 'allows a user to follow another user' do
    other_user = create(:user)

    visit user_path(other_user)

    expect do
      click_button 'フォローする'
    end.to change(Relationship, :count).by(1)

    expect(page).to have_button('フォロー中')
  end
end
