# frozen_string_literal: true

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
