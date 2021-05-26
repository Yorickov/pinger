# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sites', type: :request do
  describe 'GET /index' do
    before { create_list(:site, 2) }

    it 'returns http success' do
      get '/sites'

      expect(response).to have_http_status(:success)
    end
  end

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
      it 'redirect to :show' do
        post '/sites', params: valid_params

        expect(response).to redirect_to Site.first
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

  describe 'GET /show/:id' do
    let!(:site) { create(:site) }

    it 'returns http success' do
      get "/sites/#{site.id}"

      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /update' do
    let!(:site) { create(:site) }
    let(:valid_params) { { site: attributes_for(:site) } }
    let(:invalid_params) { { site: attributes_for(:site, :invalid) } }

    context 'with valid params' do
      it 'redirect to :show' do
        patch "/sites/#{site.id}", params: valid_params

        expect(response).to redirect_to Site.first
      end
    end

    context 'with invalid params' do
      it 'returns status 422' do
        patch "/sites/#{site.id}", params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST /destroy' do
    let!(:site) { create(:site) }

    it 'redirect to :index' do
      delete "/sites/#{site.id}"

      expect(response).to redirect_to sites_path
    end

    it 'delete site from database' do
      expect { delete "/sites/#{site.id}" }.to change(Site, :count).from(1).to(0)
    end
  end
end
