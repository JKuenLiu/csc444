require 'rails_helper'

RSpec.describe Interaction, type: :model do
    it 'is invalid without start_date' do
        should validate_presence_of(:start_date)
    end

    it 'is invalid without end_date' do
        should validate_presence_of(:end_date)
    end

    it 'start_date cannot be in the past' do
        interaction = build(:interaction, start_date: 3.days.ago)
        expect(interaction).to_not be_valid
    end

    it 'end_date cannot be before start_date' do
        interaction = build(:interaction, start_date: Date.today, end_date: 3.days.ago)
        expect(interaction).to_not be_valid
    end
end
