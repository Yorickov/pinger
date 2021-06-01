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
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:attributes) { attributes_for(:user) }

  context 'with valid values' do
    it 'valid email & password' do
      user = User.new(attributes)
      expect(user).to be_valid
    end
  end

  context 'with invalid values' do
    it 'invalid email format' do
      attributes[:email] = 'invalid_email'
      user = User.new(attributes)
      expect(user).not_to be_valid
    end

    it 'empty email' do
      attributes[:email] = ''
      user = User.new(attributes)
      expect(user).not_to be_valid
    end

    it 'empty password' do
      attributes[:password] = ''
      user = User.new(attributes)
      expect(user).not_to be_valid
    end

    it 'short password (less then 6 symbols)' do
      attributes[:password] = '12345'
      user = User.new(attributes)
      expect(user).not_to be_valid
    end
  end
end
