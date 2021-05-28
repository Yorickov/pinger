# frozen_string_literal: true

require 'rails_helper'

# TODO: add tests edit page & and update user

RSpec.describe 'Users', type: :request do
  let(:valid_user_params) { attributes_for(:user) }
  let(:invalid_user_params) { attributes_for(:user, :invalid) }

  it 'register user page' do
    get '/users/sign_up'
    expect(response).to have_http_status(:success)
  end

  it 'login page' do
    get '/users/sign_in'
    expect(response).to have_http_status(:success)
  end

  context 'with valid params' do
    it 'create user' do
      post '/users', params: { user: valid_user_params }
      expect(response).to redirect_to('/')
    end

    it 'login / log out' do
      User.create(valid_user_params)

      post '/users/sign_in', params: { user: valid_user_params }
      expect(response).to redirect_to('/')
      expect(session['warden.user.user.key']).not_to be_nil

      delete '/users/sign_out'
      expect(response).to redirect_to('/')
      expect(session['warden.user.user.key']).to be_nil
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
  end
end
