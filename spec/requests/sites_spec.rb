# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sites', type: :request do
  describe 'GET /new' do
    it 'returns http success' do
      get '/sites/new'

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /create' do
    let(:valid_params) { { site: attributes_for(:site) } }
    let(:invalid_params) { { site: attributes_for(:site, :invalid) } }

    context 'with valid params' do
      it 'redirect to root' do
        post '/sites', params: valid_params

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to root_path
      end

      it 'saves site in database' do
        expect { post '/sites', params: valid_params }.to change(Site, :count).from(0).to(1)
      end
    end

    context 'with invalid params' do
      it 'returns status 422' do
        post '/sites', params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'not save site in database' do
        expect { post '/sites', params: invalid_params }.not_to change(Site, :count)
      end
    end
  end
end
