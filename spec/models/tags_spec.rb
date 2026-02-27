# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag do
  it 'is valid with a factory' do
    tag = build(:tag)
    expect(tag).to be_valid
  end

  it 'is invalid without a name' do
    tag = build(:tag, name: nil)
    expect(tag).not_to be_valid
  end
end
