FactoryBot.define do
  factory :post do
    association :user
    content { Faker::Lorem.paragraph }

    # ✅ デフォルトで画像を付ける（image 必須バリデーション対策）
    after(:build) do |post|
      next if post.image.attached?

      post.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/test.png")),
        filename: "test.png",
        content_type: "image/png"
      )
    end

    trait :without_image do
      after(:build) do |post|
        post.image.detach if post.image.attached?
      end
    end
  end
end
