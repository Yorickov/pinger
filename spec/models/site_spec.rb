# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id             :bigint           not null, primary key
#  enabled        :boolean          default(TRUE)
#  interval       :integer          not null
#  last_pinged_at :integer
#  name           :string           not null
#  protocol       :string           not null
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
  let(:site) { build(:site) }
  let(:invalid_url) { Faker::Name.name }

  describe 'Validation' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:interval) }
    it { should validate_presence_of(:protocol) }
    it { should validate_inclusion_of(:protocol).in_array(%w[http:// https://]) }

    describe 'Url' do
      it 'creates site with correct url format' do
        expect(site).to be_valid
      end

      it 'does not create site with wrong url format' do
        def site.full_url
          'wrong url'
        end

        expect(site).not_to be_valid
        expect(site.errors[:url]).to eq ['has wrong format']
      end

      it 'does not validate fromat if url absents' do
        site.url = nil
        def site.full_url
          'wrong url'
        end
        site.validate

        expect(site.errors[:url]).to eq ["can't be blank"]
      end
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should have_many(:logs).dependent(:destroy) }
  end

  describe 'Methods' do
    describe '#full_url' do
      it { expect(site.full_url).to eq [site.protocol, site.url].join }
    end

    describe '#ping_time?' do
      let(:initial_time) { Time.now.utc }
      let(:site) { build(:site, user: build(:user), interval: 5, last_pinged_at: initial_time.to_i, enabled: true) }

      after(:all) { Timecop.return }

      context 'when site enabled' do
        context 'and more than interval time have passed since last pinged' do
          before { Timecop.freeze(initial_time + 6.minutes) }

          it { expect(site).to be_ping_time }
        end

        context 'and equal to interval time have passed since last pinged' do
          before { Timecop.freeze(initial_time + 5.minutes) }

          it { expect(site).to be_ping_time }
        end

        context 'and less than interval time have passed since last pinged' do
          before { Timecop.freeze(initial_time + 3.minutes) }

          it { expect(site).not_to be_ping_time }
        end
      end

      context 'when site disabled' do
        before { Timecop.freeze(initial_time + 6.minutes) }

        specify do
          site.enabled = false

          expect(site).not_to be_ping_time
        end
      end

      it { expect(site.full_url).to eq [site.protocol, site.url].join }
    end
  end
end
