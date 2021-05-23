# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Site, type: :model do
  describe 'Validation' do
    it { should validate_presence_of(:name) }
    it { should allow_value(Faker::Internet.url).for(:name) }
    it { should_not allow_value(Faker::Name.name).for(:name) }
  end
end
