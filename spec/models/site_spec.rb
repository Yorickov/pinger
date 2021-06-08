# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id             :bigint           not null, primary key
#  enabled        :boolean          default(TRUE)
#  last_pinged_at :integer
#  name           :string           not null
#  status         :string           default("inactive")
#  url            :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint
#
# Indexes
#
#  index_sites_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
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

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should have_many(:logs).dependent(:destroy) }
  end
end
