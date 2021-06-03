# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }

    trait :invalid do
      email { Faker::Internet.name }
      password { 'short' }
      password_confirmation { 'short' }
    end

    factory :user_with_sites do
      transient do
        sites_count { 1 }
      end

      after(:create) do |user, evaluator|
        create_list(:site, evaluator.sites_count, user: user)
      end
    end
  end
end
