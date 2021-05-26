# frozen_string_literal: true

FactoryBot.define do
  factory :site do
    name { Faker::Name.name }
    url { Faker::Internet.url }

    trait :invalid do
      url { Faker::Name.name }
    end
  end
end
