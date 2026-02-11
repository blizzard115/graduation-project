require "rails_helper"

RSpec.describe "Post management", type: :system do
  let(:password) { "password" }
  let(:user) { create(:user, password: password, password_confirmation: password) }

  before do
    driven_by(:rack_test)

    visit new_user_session_path
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    click_button "ログイン"
  end

  it "allows a user to create a post with an image" do
    visit new_post_path

    fill_in "キャプション", with: "My first outfit post"

    attach_file "post_image",
      Rails.root.join("spec/fixtures/files/test.png")

    click_button "投稿する"

    expect(page).to have_content("投稿しました")

    post = Post.order(:created_at).last
    expect(post.content).to eq("My first outfit post")
    expect(post.image).to be_attached
  end
end
