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
FactoryBot.define do
  factory :site do
    name { Faker::Name.name }
    url { Faker::Internet.url }

    trait :invalid do
      url { Faker::Name.name }
    end
  end
end
