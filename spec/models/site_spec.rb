# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Site, type: :model do
  let(:valid_url) { Faker::Internet.url }
  let(:invalid_url) { Faker::Name.name }

  describe 'Validation' do
    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:url) }
    it { should allow_value(valid_url).for(:url) }
    it { should_not allow_value(invalid_url).for(:url) }
  end
end
