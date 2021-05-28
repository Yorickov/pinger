# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    password_confirmation { "password" }

    trait :invalid do
      email { Faker::Internet.name }
      password { "short" }
      password_confirmation { "short" }
    end
  end
end
