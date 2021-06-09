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
FactoryBot.define do
  factory :site do
    name { Faker::Name.name }
    url { 'github.com' }

    protocol { 'https://' }
    interval { 1 }

    user

    # TODO: change
    trait :invalid do
      url { nil }
    end
  end
end
