# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id              :bigint           not null, primary key
#  checking_string :string
#  enabled         :boolean          default(TRUE)
#  interval        :integer          not null
#  last_pinged_at  :integer
#  name            :string           not null
#  protocol        :string           not null
#  status          :string           default("inactive")
#  timeout         :integer          default(10)
#  url             :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint
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
    protocol { 'http://' }
    interval { 1 }
    checking_string { nil }
    timeout { 10 }

    user

    trait :invalid do
      name { nil }
    end
  end
end
