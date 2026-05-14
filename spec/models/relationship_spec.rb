RSpec.describe Relationship do
  it 'is valid with a follower and followed' do
    follower = create(:user)
    followed = create(:user)

    relationship = build(:relationship, follower: follower, followed: followed)

    expect(relationship).to be_valid
  end

  it 'does not allow duplicate relationships' do
    relationship = create(:relationship)
    duplicate = build(
      :relationship,
      follower: relationship.follower,
      followed: relationship.followed
    )

    expect(duplicate).not_to be_valid
  end

  it 'does not allow following yourself' do
    user = create(:user)
    relationship = build(:relationship, follower: user, followed: user)

    expect(relationship).not_to be_valid
  end
end