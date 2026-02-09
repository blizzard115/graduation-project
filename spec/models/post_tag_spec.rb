require "rails_helper"

RSpec.describe PostTag, type: :model do
  it "is valid with a factory" do
    post_tag = build(:post_tag)
    expect(post_tag).to be_valid
  end
end