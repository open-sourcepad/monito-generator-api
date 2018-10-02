require 'rails_helper'

RSpec.describe User, type: :model do
  # Validation Tests
  it 'has a valid factory' do
    user_fact = FactoryBot.build(:user)

    expect(user_fact).to be_valid
  end

  it 'is invalid without a user_name' do
    user_fact = FactoryBot.build(:user, user_name: nil)

    expect(user_fact).not_to be_valid
  end

  it 'is invalid without an email' do
    user_fact = FactoryBot.build(:user, email: nil)

    expect(user_fact).not_to be_valid
  end

  it 'is invalid without a provided password' do
    user_fact = FactoryBot.build(:user, password_hash: nil)

    expect(user_fact).not_to be_valid
  end

  it { should validate_uniqueness_of(:user_name) }

  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }

  # Association tests go here
end
