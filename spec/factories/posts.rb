FactoryBot.define do
  factory :post do
    association :user
    content { Faker::Lorem.paragraph }

    after(:build) do |post|
      post.image.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/test.png")),
        filename: "test.png",
        content_type: "image/png"
      )
    end
  end
end