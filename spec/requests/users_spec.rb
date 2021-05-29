# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:valid_user_params) { attributes_for(:user) }
  let(:invalid_user_params) { attributes_for(:user, :invalid) }
  subject(:user_signed_in?) { !session['warden.user.user.key'].nil? }

  context 'when user logged in' do
    it 'register user page' do
      sign_in User.create(valid_user_params)

      get '/users/sign_up'
      expect(response).to redirect_to('/')
    end

    it 'edit user page' do
      sign_in User.create(valid_user_params)

      get '/users/edit'
      expect(response).to have_http_status(:success)
    end
  end

  context 'when user not logged in' do
    it 'register user page' do
      get '/users/sign_up'
      expect(response).to have_http_status(:success)
    end
  
    it 'login page' do
      get '/users/sign_in'
      expect(response).to have_http_status(:success)
    end

    it 'edit user page' do
      get '/users/edit'
      expect(response).to redirect_to('/users/sign_in')
    end
  end

  context 'with valid params' do
    it 'create user' do
      post '/users', params: { user: valid_user_params }
      expect(response).to redirect_to('/')
    end

    it 'login' do
      User.create(valid_user_params)

      post '/users/sign_in', params: { user: valid_user_params }
      expect(response).to redirect_to('/')
      expect(user_signed_in?).to be_truthy
    end

    it 'log out' do
      sign_in User.create(valid_user_params)

      delete '/users/sign_out'
      expect(response).to redirect_to('/')
      expect(user_signed_in?).to be_falsey
    end

    it 'update user' do
      sign_in User.create(valid_user_params)
      updated_attributes = attributes_for(:user)
      updated_attributes[:current_password] = updated_attributes[:password]

      put '/users', params: { user: updated_attributes }
      expect(response).to redirect_to('/')
    end
  end

  context 'with invalid params' do
    it 'create user' do
      post '/users', params: { user: invalid_user_params }
      expect(response).not_to have_http_status(:redirect)
    end

    it 'login' do
      post '/users/sign_in', params: { user: valid_user_params }
      expect(response).not_to have_http_status(:redirect)
      expect(session['warden.user.user.key']).to be_nil
    end

    it 'update user' do
      sign_in User.create(valid_user_params)
      updated_attributes = attributes_for(:user)
      updated_attributes[:current_password] = 'wrong_current_password'

      put '/users', params: { user: updated_attributes }
      expect(response).not_to have_http_status(:redirect)
    end
  end
end
