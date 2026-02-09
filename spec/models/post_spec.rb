require "rails_helper"

RSpec.describe Post, type: :model do
  it "is valid with a factory" do
    post = build(:post)
    expect(post).to be_valid
  end
end
