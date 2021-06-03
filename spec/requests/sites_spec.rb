# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sites', type: :request do
  let(:user1) { create(:user_with_sites) }
  let(:user2) { create(:user) }

  describe 'GET /index' do
    context 'as authenticated User' do
      before { sign_in(user1) }

      it 'returns 200' do
        get '/sites'

        expect(response).to have_http_status(:success)
      end
    end

    context 'as Guest' do
      it 'redirect to login form' do
        get '/sites'

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /new' do
    context 'as authenticated User' do
      before { sign_in(user1) }

      it 'returns 200' do
        get '/sites/new'

        expect(response).to have_http_status(:success)
      end
    end

    context 'as Guest' do
      it 'redirect to login form' do
        get '/sites/new'

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /create' do
    let(:valid_params) { { site: attributes_for(:site) } }
    let(:invalid_params) { { site: attributes_for(:site, :invalid) } }

    context 'as authenticated User' do
      before { sign_in(user1) }

      context 'with valid params' do
        it 'redirect to :show' do
          post '/sites', params: valid_params

          expect(response).to redirect_to user1.sites.second
        end

        it 'saves site in database' do
          expect { post '/sites', params: valid_params }.to change(Site, :count).by(1)
        end
      end

      context 'with invalid params' do
        it 'returns 422' do
          post '/sites', params: invalid_params

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'does not save site in database' do
          expect { post '/sites', params: invalid_params }.not_to change(Site, :count)
        end
      end
    end

    context 'as Guest' do
      it 'does not save site in database' do
        expect { post '/sites', params: valid_params }.to_not change(Site, :count)
      end

      it 'redirects to login form' do
        post '/sites', params: valid_params

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET /show:id' do
    let(:site) { user1.sites.first }

    context 'as authenticated User' do
      before { sign_in(user1) }

      it 'returns 200' do
        get "/sites/#{site.id}"

        expect(response).to have_http_status(:success)
      end
    end

    context 'as Guest' do
      it 'redirect to login form' do
        get "/sites/#{site.id}"

        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /update' do
    let(:valid_params) { { site: attributes_for(:site) } }
    let(:invalid_params) { { site: attributes_for(:site, :invalid) } }
    let!(:site) { user1.sites.first }

    context 'as authenticated authorized User' do
      before { sign_in(user1) }

      context 'with valid params' do
        before { patch "/sites/#{site.id}", params: valid_params }

        it 'changes site attributes' do
          site.reload

          expect(site.name).to eq valid_params[:site][:name]
          expect(site.url).to eq valid_params[:site][:url]
        end

        it 'redirect to :show' do
          expect(response).to redirect_to site
        end
      end

      context 'with invalid params' do
        before { patch "/sites/#{site.id}", params: invalid_params }

        it 'does not change site attributes' do
          original_name = site.name
          site.reload

          expect(site.name).to eq original_name
        end

        it 'returns 422' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'as authenticated not authorized User' do
      before { sign_in(user2) }
      before { patch "/sites/#{site.id}", params: valid_params }

      it 'does not changes site attributes' do
        original_name = site.name

        site.reload
        expect(site.name).to eq original_name
      end

      it 'returns 403' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'as Guest' do
      before { patch "/sites/#{site.id}", params: valid_params }

      it 'does not changes site attributes' do
        original_name = site.name

        site.reload
        expect(site.name).to eq original_name
      end

      it 'redirects to login form' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST /delete' do
    let!(:site) { user1.sites.first }

    context 'as authenticated authorized User' do
      before { sign_in(user1) }

      it 'redirects to :index' do
        delete "/sites/#{site.id}"

        expect(response).to redirect_to sites_path
      end

      it 'deletes site from database' do
        expect { delete "/sites/#{site.id}" }.to change(Site, :count).by(-1)
      end
    end

    context 'as authenticated not authorized User' do
      before { sign_in(user2) }

      it 'returns 403' do
        delete "/sites/#{site.id}"

        expect(response).to have_http_status(:forbidden)
      end

      it 'does not delete site from database' do
        expect { delete "/sites/#{site.id}" }.not_to change(Site, :count)
      end
    end

    context 'as Guest' do
      it 'redirects to login form' do
        delete "/sites/#{site.id}"

        expect(response).to redirect_to new_user_session_path
      end

      it 'does not delete site from database' do
        expect { delete "/sites/#{site.id}" }.not_to change(Site, :count)
      end
    end
  end
end
