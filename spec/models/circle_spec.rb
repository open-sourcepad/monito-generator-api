require 'rails_helper'

RSpec.describe Circle, type: :model do
  it 'has a valid factory' do
    circle_fact = FactoryBot.build(:circle)
    expect(circle_fact).to be_valid
  end

  it 'is invalid without a circle_name' do
    circle_fact = FactoryBot.build(:circle, circle_name: nil)

    expect(circle_fact).not_to be_valid
  end

  it 'is invalid without budget' do
    circle_fact = FactoryBot.build(:circle, budget: nil)

    expect(circle_fact).not_to be_valid
  end

  it 'is invalid without exchange_date' do
    circle_fact = FactoryBot.build(:circle, exchange_date: nil)

    expect(circle_fact).not_to be_valid
  end

  it 'is invalid without owner' do
    circle_fact = FactoryBot.build(:circle, owner: nil)

    expect(circle_fact).not_to be_valid
  end
end
