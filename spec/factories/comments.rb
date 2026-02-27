# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { 'テストコメント' }
    association :user
    association :post
  end
end
